rinix:
	cd src
	echo "If build fails, set up aliases for your cross compiler (i686-elf)"
	i686-elf-as boot.s -o boot.o
	i686-elf-gcc -c kernel/main.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	i686-elf-gcc -T linker.ld -o rinix.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

	# check for multiboot

	if grub-file --is-x86-multiboot rinix.bin; then
		echo multiboot confirmed
	else
		echo the file is not multiboot
	fi

	# build final image

	mkdir build
	cp rinix.bin build/rinix.bin
	cp grub.cfg build/grub.cfg
	grub-mkrescue -o build/rinix.iso build

run-qemu:
	qemu-system-i386 -cdrom build/rinix.bin

install:
	read -p "Enter location of device (eg. /dev/sdx): " dev_loc
	sudo dd if=build/rinix.iso of=$dev_loc
	sync