extproc c:/gnu/bin/sh.exe
#!/bin/sh -
#
#	@(#)recover.in	8.8 (Berkeley) 10/10/96
#
# Script to recover nvi edit sessions.

RECDIR="C:/tmp/recover.vi"
SENDMAIL="C:/TCPIP/BIN/sendmail"

echo 'Recovering nvi editor sessions.'

# Check editor backup files.
vibackup=`echo $RECDIR/vi*`
if [ "$vibackup" != "$RECDIR/vi*" ]; then
	for i in $vibackup; do
		# Only test files that are readable.
		if test ! -r $i; then
			continue
		fi

		# Unmodified nvi editor backup files either have the
		# execute bit set or are zero length.  Delete them.
		if test -x $i -o ! -s $i; then
			rm $i
		fi
	done
fi

# It is possible to get incomplete recovery files, if the editor crashes
# at the right time.
virecovery=`echo $RECDIR/re*`
if [ "$virecovery" != "$RECDIR/re*" ]; then
	for i in $virecovery; do
		# Only test files that are readable.
		if test ! -r $i; then
			continue
		fi

		# Delete any recovery files that are zero length, corrupted,
		# or that have no corresponding backup file.  Else send mail
		# to the user.
		recfile=`awk '/^X-vi-recover-path:/{print $2}' < $i`
		if test -n "$recfile" -a -s "$recfile"; then
			$SENDMAIL -t < $i
		else
			rm $i
		fi
	done
fi
