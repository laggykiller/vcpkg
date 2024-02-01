--- a/mpz/inp_raw.c	Tue Dec 22 23:49:51 2020 +0100
+++ b/mpz/inp_raw.c	Thu Oct 21 19:06:49 2021 +0200
@@ -88,8 +88,11 @@
 
   abs_csize = ABS (csize);
 
+  if (UNLIKELY (abs_csize > ~(mp_bitcnt_t) 0 / 8))
+    return 0; /* Bit size overflows */
+
   /* round up to a multiple of limbs */
-  abs_xsize = BITS_TO_LIMBS (abs_csize*8);
+  abs_xsize = BITS_TO_LIMBS ((mp_bitcnt_t) abs_csize * 8);
 
   if (abs_xsize != 0)
     {
