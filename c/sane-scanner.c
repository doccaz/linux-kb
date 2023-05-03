#include <stdio.h>
#include <sane/sane.h>

int main(int argc, char *argv[]) {

        SANE_Int version;
        SANE_Status status;
        SANE_Handle handle;
        const SANE_Device ** devices;

        status = sane_init(&version, NULL);
        if (status != SANE_STATUS_GOOD) {
                printf("Fail to init sane: %s\n", sane_strstatus(status));
                return -1;
        }

        printf("Sane backend version: %i\n", version);

        status = sane_get_devices(&devices, SANE_TRUE);
        if (status != SANE_STATUS_GOOD) {
                printf("Fail to list devices: %s\n", sane_strstatus(status));
                sane_exit();
                return -1;
        }

        if (devices[0] == NULL) {
                printf("No device found\n");
                sane_exit();
                return 0;
        }

        status = sane_open(devices[0]->name, &handle);
        if (status != SANE_STATUS_GOOD) {
                printf("Fail to open device (%s): %s\n",
                       devices[0]->name,
                       sane_strstatus(status));
                sane_exit();
                return -1;
        }

        printf("Device is open: %s\n", devices[0]->name);
        sane_close(handle);
        sane_exit();

        return 0;
}
