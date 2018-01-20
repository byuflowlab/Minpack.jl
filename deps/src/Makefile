FC = gfortran
LIB = hybrid
FFLAGS = -shared -O2 -fPIC
SUFFIX = dylib

OBJ = $(shell ls *.f)

all : lib$(LIB).$(SUFFIX)

lib$(LIB).$(SUFFIX) : $(OBJ)
	$(FC) $(FFLAGS) $(OBJ) -o $@

clean :
	rm -f *.$(SUFFIX)

# gfortran -shared -O2 *.f -o libhybrd.dylib -fPIC
