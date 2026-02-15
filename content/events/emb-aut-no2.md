---
title: "Embedded Linux"
date: 2024-02-15
description: "Join us for the Embedded Linux event – exploring Yocto, ELBE, and RISC-V emulation."
tags: ["embedded-linux", "yocto", "risc-v", "elbe"]
event:
  number: 2
  location: "Digital Society, Graben 17/10, 1010 Vienna"
  date: "Thursday, February 15th 2024, 18:00 to 22:00 CET"
---

## event@embaut:~# echo "EMBEDDED LINUX" > /dev/topic

Join us for the Embedded Linux event, where we will explore the latest developments in this rapidly evolving field. Learn about how Embedded Linux is being used to power a wide range of devices, from smartphones to industrial machinery. Get practical advice from experts on how to develop and deploy Embedded Linux applications.

## Talks

- **The Yocto Project® - A Bird's Eye View** — *Robert Berger, Reliable Embedded Systems e.U.*
- **The Embedded Linux Build Environment (ELBE)** — *Dr. Ralf Schlatterbeck, Open Source Consultant*
- **Linux on an emulated RISC-V** — *Franz Flasch, Embedded Software Architect*

---

### The Yocto Project® - A Bird's Eye View

What is Embedded Linux, a Linux Distro, the Yocto Project®? We'll see Features, Challenges, and Terminology. Last but not least a quick overview of the OpenEmbedded Architecture Workflow.

**About:** Robert Berger is the CEO and Embedded Software Evangelist at Reliable Embedded Systems e.U. with headquarters in St. Barbara, Austria. His areas of expertise are training and consulting on the Yocto Project®, Embedded Software, and Real-Time. Robert has extensive experience from real-time systems to multi core application processors and embedded Linux with focus on free and open-source software.

---

### The Embedded Linux Build Environment - ELBE

ELBE is a versatile tool for crafting customized root filesystems tailored to embedded Linux systems. It leverages a Debian-compatible repository (Debian, Raspbian, etc.) to seamlessly assemble the root filesystem from pre-compiled Debian packages, ensuring reproducibility.

From the humble Raspberry Pi with its SD card to resource-constrained embedded platforms with on-chip or on-board NAND or NOR flash, ELBE empowers you to build tailored root filesystem images, eliminating the need for bulky, pre-built images often found online.

The presentation delves into the intricacies of ELBE, including the creation of root filesystem images for single-board computers powered by Allwinner chips – Orange Pi, Banana Pi, and Olimex boards, to name a few. These boards often ship with outdated manufacturer-provided Linux kernels, yet ELBE enables the utilization of the mainline kernel for these devices.

ELBE further extends its capabilities to deeply embedded systems with strict storage limitations, allowing you to generate UBIFS images for root filesystems as small as 60 MB.

**About:** Dr. Ralf Schlatterbeck is an experienced Open Source consultant with a focus on security, Internet of Things, Embedded Linux, telephony projects, voice communication, web applications, and technical-scientific applications.

---

### Linux on an emulated RISC-V

This presentation introduces riscv_em, a lightweight and easy-to-understand RISC-V emulator. The emulator is capable of running Linux, making it a valuable tool for exploring the bare minimum requirements of operating system execution. The project prioritizes simplicity over efficiency, allowing developers to grasp the intricacies of the RISC-V instruction set architecture (ISA) through its transparent code structure.

**About:** Franz Flasch is an experienced embedded software architect passionate about designing and developing reliable embedded systems. He has expertise in various embedded platforms, microcontroller architectures, and Linux-based operating systems.
