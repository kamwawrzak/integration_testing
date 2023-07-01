package handler

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/health"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"

	pb "example.com/m/genproto"
)

type Server struct{
	pb.UnimplementedExampleServiceServer
}

func (s *Server) SayHello(ctx context.Context, req *pb.HelloRequest) (*pb.HelloResponse, error) {
	message := "Hello, " + req.Name
	return &pb.HelloResponse{Message: message}, nil
}

func StartServer(){

		lis, err := net.Listen("tcp", ":50051")
		if err != nil {
			log.Fatalf("Failed to listen: %v", err)
		}

		grpcServer := SetupServer()

		log.Println("gRPC server is listening on port 50051")
		grpcServer.Serve(lis)
		pb.RegisterExampleServiceServer(grpcServer, &Server{})
}

func SetupServer() *grpc.Server{
	
		grpcServer := grpc.NewServer()
		// Register the health server
		healthServer := health.NewServer()
		healthServer.SetServingStatus("", healthpb.HealthCheckResponse_SERVING)
		healthpb.RegisterHealthServer(grpcServer, healthServer)
		reflection.Register(grpcServer)
		return grpcServer
}