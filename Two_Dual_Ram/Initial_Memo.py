#!/usr/bin/env python
import os
import sys
import time
#=============================================================#
def main():
    with open('./Init_Memory.txt','w') as outfile:
        for i in xrange(256):
            outfile.write("%d\n"%0)
#=============================================================#
if __name__ == "__main__":
    sys.exit(main())
        
