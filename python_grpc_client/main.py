import grpc
import messenger_pb2
import messenger_pb2_grpc
from datetime import datetime

if __name__ == "__main__":
    while True:
        try:
            with grpc.insecure_channel('localhost:10000') as channel:
                stub = messenger_pb2_grpc.MessengerStub(channel)
                stub.PostMessage(messenger_pb2.MessageRequest(message="Hello"))

                for res in stub.FetchMessage(messenger_pb2.MessageResponse()):
                    print(res.message)
                    message_receiving_time = datetime.now()
        except (KeyboardInterrupt, SystemExit):
            print('Shutting down gracefully...')
            break
        except Exception as err:
            print(f'Unexpected error caused. <{type(err)}> {err}')
            connection_lost_time = datetime.now()
            print(f'Total Idle Time: {(connection_lost_time - message_receiving_time).seconds}s')
