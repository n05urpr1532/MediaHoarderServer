#!/usr/bin/env bash

transportselect() {
  tee <<- EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set Clone Method
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: Please visit the link and understand what your doing first!

LINK : https://github.com/n05urpr1532-MHA-Team/PTS-Team/wiki/PTS-Clone

[1] Move  Unencrypt: Data > GDrive | Novice  | 750GB Daily Transfer Max
[2] Move  Encrypted: Data > GDrive | Novice  | 750GB Daily Transfer Max
[3] Blitz Unencrypt: Data > TDrive | Complex | Exceed 750GB Transport Cap
[4] Blitz Encrypted: Data > TDrive | Complex | Exceed 750GB Transport Cap

[5] Local Edition  : Local HDs     | Easy    | Utilizes System's HD's Only

[Z] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty

  case $typed in
    1)
      echo "mu" > /var/mhs/state/uploader.transport
      echo "Move" > /var/mhs/state/pg.transport
      ;;
    2)
      echo "me" > /var/mhs/state/uploader.transport
      echo "Move Encrypted" > /var/mhs/state/pg.transport
      ;;
    3)
      echo "bu" > /var/mhs/state/uploader.transport
      echo "Blitz" > /var/mhs/state/pg.transport
      ;;
    4)
      echo "be" > /var/mhs/state/uploader.transport
      echo "Blitz Encrypted" > /var/mhs/state/pg.transport
      ;;
    5)
      echo "le" > /var/mhs/state/uploader.transport
      echo "Local Edition" > /var/mhs/state/pg.transport
      ;;
    z)
      exit
      ;;
    Z)
      exit
      ;;
    *)
      transportselect
      ;;
  esac
}
