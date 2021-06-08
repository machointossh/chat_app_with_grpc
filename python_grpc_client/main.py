import grpc
import messenger_pb2
import messenger_pb2_grpc
from time import sleep

if __name__ == "__main__":
    for retry in range(5):
        try:
            with grpc.insecure_channel('localhost:10000') as channel:
                stub = messenger_pb2_grpc.MessengerStub(channel)
                stub.PostMessage(messenger_pb2.MessageRequest(message="Hello"))

                for res in stub.FetchMessage(messenger_pb2.MessageResponse()):
                    print(res.message)
        except (KeyboardInterrupt, SystemExit):
            print('Shutting down gracefully...')
            break
        except Exception as err:
            print(f'Unexpected error caused. retry:{retry} <{type(err)}> {err}')
            sleep(1)
