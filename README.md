# mkdistro

mkdistro is a simple utility to make a tiny GRUB/Toybox/Linux distro. It can easily be configured, by editing `build.sh`.

> [!IMPORTANT]
> This script only builds for x86_64 machines and will likely only work on such machines.

## Example

Making a distro using default settings:

```bash
podman build -t mkdistro .
mkdir output
podman run -v ./output:/output -it mkdistro
```

Testing it:

```bash
qemu-system-x86_64 -cdrom output/boot.iso
```
