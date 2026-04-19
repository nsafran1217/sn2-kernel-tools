savedcmd_sn2_fsb_test.mod := printf '%s\n'   sn2_fsb_test.o | awk '!x[$$0]++ { print("./"$$0) }' > sn2_fsb_test.mod
