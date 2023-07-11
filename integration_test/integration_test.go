package main_test

import (
	"context"
	"fmt"
	"net"
	"testing"
	"time"

	"github.com/stretchr/testify/suite"
	"google.golang.org/grpc"
	"google.golang.org/grpc/test/bufconn"
	"example.com/m/handler"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"github.com/gocraft/dbr"
	_ "github.com/go-sql-driver/mysql"
)

type IntegrationTestSuite struct {
	suite.Suite
	conn *grpc.ClientConn
	dbConn *dbr.Connection
	lis *bufconn.Listener
	server *grpc.Server
}

func TestIntegrationTestSuite(t *testing.T) {
	suite.Run(t, new(IntegrationTestSuite))
}

func (suite *IntegrationTestSuite) SetupSuite(){
	var err error
	// Establish a database connection
	suite.dbConn, err = dbr.Open("mysql", "root:mypassword@tcp(my-mysql:3306)/test_db", nil)
	//suite.dbConn, err = dbr.Open("mysql", "root:mypassword@tcp(my-mysql:3306)/test_db", nil)
	if err != nil {
		fmt.Println("Failed to connect to the database:", err)
		//suite.NoError(err)
	}
	for i:=0; i<6; i++ {
		err = suite.dbConn.Ping()
		if err == nil {
			break
		}
		time.Sleep(2 * time.Second)

	}
	
	//suite.NoError(err)

}

func (suite *IntegrationTestSuite) TearDownSuite() {
	suite.dbConn.Close()
}

func (suite *IntegrationTestSuite) SetupTest() {
	// Create an in-memory listener using bufconn
	lis := bufconn.Listen(1024 * 1024)
	suite.lis = lis

	// Dial the server using the in-memory connection
	
	conn, err := grpc.DialContext(context.Background(), "", grpc.WithContextDialer(func(context.Context, string) (net.Conn, error) {
		return lis.Dial()
	}), grpc.WithInsecure())
	if err != nil {
		suite.T().Errorf("failed to dial server: %v", err)
	}
	suite.conn = conn
}

func (suite *IntegrationTestSuite) TearDownTest(){
	if suite.server != nil {
		suite.server.Stop()
	}
	if suite.conn != nil {
		suite.conn.Close()
	}
	if suite.lis != nil {
		_ = suite.lis.Close()
	}
}

func (suite *IntegrationTestSuite) TestHealthCheck() {
	suite.server = handler.SetupServer()

	go func() {
		if err := suite.server.Serve(suite.lis); err != nil {
			//suite.NoError(err)

		}
	}()

	time.Sleep(1 * time.Second)

	healthClient := healthpb.NewHealthClient(suite.conn)

	req := &healthpb.HealthCheckRequest{}

	fmt.Println("Status con: ", suite.conn.GetState())
	resp, err := healthClient.Check(context.Background(), req)
	suite.NoError(err)
	suite.Equal(healthpb.HealthCheckResponse_SERVING, resp.GetStatus())
	fmt.Println("Test 1 end")
	}

