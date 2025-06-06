echo "COMPILING"
zig build-exe zcat.zig

if [[ $? != 0 ]]; then
	echo "FAILED"
else
	echo "DONE"
fi
