hack.md: fixchecksum.py fixoptions.py hack.asm.bin
	python fixoptions.py
	python $<

hack.asm.bin: hack.asm
	asmx -e -b -C 68k $< || { rm -rf $@; exit 1; }

clean:
	rm -rf hack.asm.bin hack.md
