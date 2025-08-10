#ifndef __ASM_BARRIER_H
#define __ASM_BARRIER_H

#define isb() __asm__ __volatile__ ("isb" : : : "memory")
#define dmb() __asm__ __volatile__ ("" : : : "memory")
#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" : : "r" (0) : "memory")
#define wmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" : : "r" (0) : "memory")

#endif /* __ASM_BARRIER_H */
