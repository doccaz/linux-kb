#include <signal.h>
#include <sys/types.h>
#include <unistd.h>


int main() {
	kill(getpid(), SIGSEGV);
}

