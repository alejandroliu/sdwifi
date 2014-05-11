#!/bin/sh
#
# Create aliases for commands
#
# ftpget beijing alias.sh
[ -z "$bbext" ] && bbext=/sbin/busybox-ext
bb=$($bbext which busybox)
if [ -z "$bb" ] ;then
  echo "Missing busybox" 1>&2
  exit 1
fi

cat >/bin/bbx <<-'EOF'
	#!/bin/sh
	exec /sbin/busybox-ext "$@"
	EOF
chmod 755 /bin/bbx

check_app() {
  local match=$($bb --list | $bbext awk '$1 == "'$1'" { print $1 }')
  [ -n "$match" ]
}

for xapplet in $($bbext --list)
do
  exe=$($bbext which $xapplet 2>/dev/null)
  if [ -n "$exe" ] ; then
    # A file of that name already exists
    [ ! -L "$exe" -a -e "$exe" ] && continue ; # Is not a symlink...
    # Check if current bb defines it..
    check_app $xapplet && continue
    # Current $bb does not define it, so we remove the link
    rm -f $exe
  fi
  ln -s $bbext /usr/bin/$xapplet
done
