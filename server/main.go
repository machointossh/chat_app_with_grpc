package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"time"

	pb "github.com/bot6rice/chat_app_with_grpc/server/messenger"
	"github.com/golang/protobuf/ptypes/empty"
	"github.com/golang/protobuf/ptypes/timestamp"

	"github.com/golang/protobuf/ptypes"
	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"
)

const port = 9090

type Server struct {
	pb.UnimplementedMessengerServer
	responses []*pb.MessageResponse
}

func sendStreamMessageResponse(s pb.Messenger_FetchMessageServer, m string, ts *timestamp.Timestamp) error {
	log.Printf("Sent: %v (%v)", m, ts)
	return s.Send(&pb.MessageResponse{
		Message:   m,
		Timestamp: ts,
	})
}

func (s *Server) FetchMessage(_ *empty.Empty, stream pb.Messenger_FetchMessageServer) error {
	log.Println("FetchMessage")
	for _, r := range s.responses {
		if err := sendStreamMessageResponse(stream, r.GetMessage(), r.GetTimestamp()); err != nil {
			return err
		}
	}

	previousCount := len(s.responses)

	for {
		currentCount := len(s.responses)
		if previousCount < currentCount {
			r := s.responses[currentCount-1]
			if err := sendStreamMessageResponse(stream, r.GetMessage(), r.GetTimestamp()); err != nil {
				return err
			}
		}
		previousCount = currentCount
	}
}

func (s *Server) PostMessage(ctx context.Context, r *pb.MessageRequest) (*pb.MessageResponse, error) {
	log.Println("PostMessage")

	m := r.GetMessage()
	t, err := ptypes.TimestampProto(time.Now())
	if err != nil {
		log.Fatalf("Faield to parse time to timestamp: %v\n", err)
	}

	log.Printf("Received: %s", m)
	res := &pb.MessageResponse{Message: m, Timestamp: t}
	s.responses = append(s.responses, res)
	return res, nil
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
		log.Printf("Starting messenger server.")
		if err := grpcServer.Serve(messengerLis); err != nil {
			log.Fatalf("failed to serve: %v", err)
		}
	}()
	log.Printf("Starting healthcheck server.")
	if err := grpcServer.Serve(healthLis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}

}
