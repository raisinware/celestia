CC = clang
LD = lld-link

CFLAGS = -I include -target x86_64-pc-win32-coff -fno-stack-protector \
         -fshort-wchar -mno-red-zone
LDFLAGS = -subsystem:efi_application -nodefaultlib -dll

.PHONY: all clean

all: boot.efi
clean:
	rm *.efi
	rm *.o
	rm *.lib
	rm *.dep

efi_main.o: efi_main.c
	$(CC) $(CFLAGS) -MM $< > $<.dep
	$(CC) $(CFLAGS) -c $< -o $@

-include efi_main.c.dep

boot.efi: efi_main.o
	$(LD) $(LDFLAGS) -entry:efi_main $< -out:$@
