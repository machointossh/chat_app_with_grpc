package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"time"

	pb "github.com/botamochi-rice/chat_app_with_grpc/server/messenger"
	"github.com/golang/protobuf/ptypes/empty"

	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"
)

const port = 9090

type Server struct {
	pb.UnimplementedMessengerServer
	requests []*pb.MessageRequest
}

func (s *Server) FetchMessage(_ *empty.Empty, stream pb.Messenger_FetchMessageServer) error {
	for _, r := range s.requests {
		if err := stream.Send(&pb.MessageResponse{Message: r.GetMessage()}); err != nil {
			return err
		}
	}

	previousCount := len(s.requests)

	for {
		currentCount := len(s.requests)
		if previousCount < currentCount {
			r := s.requests[currentCount-1]
			log.Printf("Sent: %v", r.GetMessage())
			if err := stream.Send(&pb.MessageResponse{Message: r.GetMessage()}); err != nil {
				return err
			}
		}
		previousCount = currentCount
	}
}

func (s *Server) PostMessage(ctx context.Context, r *pb.MessageRequest) (*pb.MessageResponse, error) {
	// TODO: Implement
	m := r.GetMessage()
	log.Printf("Received: %s", m)
	req := &pb.MessageRequest{Message: m + ": " + time.Now().Format("2006-01-02 15:04:05")}
	s.requests = append(s.requests, req)
	return &pb.MessageResponse{Message: m}, nil
}

func main() {
	// gRPC Server
	messengerPort := fmt.Sprintf(":%d", port)
	messengerLis, err := net.Listen("tcp4", messengerPort)
	if err != nil {
		log.Fatalf("net.Listen(tcp4, %q) failed: %v", messengerPort, err)
	}
	grpcServer := grpc.NewServer()
	pb.RegisterMessengerServer(grpcServer, &Server{})
	reflection.Register(grpcServer)

	// Health Server
	healthPort := fmt.Sprintf(":%d", port+1)
	healthLis, err := net.Listen("tcp4", healthPort)
	if err != nil {
		log.Fatalf("net.Listen(tcp4, %q) failed: %v", healthPort, err)
	}
	healthServer := health.NewServer()
	healthServer.SetServingStatus("", healthpb.HealthCheckResponse_SERVING)
	healthpb.RegisterHealthServer(grpcServer, healthServer)

	// Start servers
	go func() {
		if err := grpcServer.Serve(messengerLis); err != nil {
			log.Fatalf("failed to serve: %v", err)
		}
	}()
	if err := grpcServer.Serve(healthLis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}

}
