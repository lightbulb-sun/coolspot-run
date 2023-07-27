FILENAME = 'hack.asm.bin'

OLD_OPTIONS_START = 0x797a1
OLD_OPTIONS_END = 0x797ff

NEW_OPTIONS_START = 0xff400

with open(FILENAME, 'rb') as inf:
    rom = bytearray(inf.read())

print('Patching options screen.')

old_options = rom[OLD_OPTIONS_START:OLD_OPTIONS_END]
run_button = b'\x02\x05\x04\x01RUN -A\x02\xeb\x04\x01'
new_options = old_options[:0x31] + run_button + old_options[0x35:]

new_options_end = NEW_OPTIONS_START + len(new_options)

pre_new_options = rom[:NEW_OPTIONS_START]
post_new_options = rom[new_options_end:]

rom = pre_new_options + new_options + post_new_options

with open(FILENAME, 'wb') as outf:
    outf.write(rom)
