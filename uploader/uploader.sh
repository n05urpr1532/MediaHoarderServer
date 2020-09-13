#!/usr/bin/env bash

source /opt/mhs/lib/uploader/functions/functions.sh
source /opt/mhs/lib/uploader/functions/variables.sh
source /opt/mhs/lib/uploader/functions/rclonesettings.sh
source /opt/mhs/lib/uploader/functions/keys.sh
source /opt/mhs/lib/uploader/functions/keyback.sh
source /opt/mhs/lib/uploader/functions/uploader.sh
source /opt/mhs/lib/uploader/functions/gaccount.sh
source /opt/mhs/lib/uploader/functions/publicsecret.sh
source /opt/mhs/lib/uploader/functions/variables.sh
source /opt/mhs/lib/uploader/functions/transportselect.sh
source /opt/mhs/lib/uploader/functions/projectname.sh
source /opt/mhs/lib/uploader/functions/clonestartoutput.sh
source /opt/mhs/lib/uploader/functions/cloneclean.sh
source /opt/mhs/lib/uploader/functions/oauth.sh
source /opt/mhs/lib/uploader/functions/passwords.sh
source /opt/mhs/lib/uploader/functions/oauthcheck.sh
source /opt/mhs/lib/uploader/functions/keysbuild.sh
source /opt/mhs/lib/uploader/functions/emails.sh
source /opt/mhs/lib/uploader/functions/deploy.sh
source /opt/mhs/lib/uploader/functions/deploymove.sh
source /opt/mhs/lib/uploader/functions/deployblitz.sh
source /opt/mhs/lib/uploader/functions/multihd.sh
source /opt/mhs/lib/uploader/functions/deploylocal.sh
source /opt/mhs/lib/uploader/functions/createtdrive.sh
source /opt/mhs/lib/uploader/functions/bwlimit.sh
################################################################################

# (functions.sh) Ensures variables and folders exist
uploadervars

# (functions.sh) User cannot proceed until they set transport and data type
mustset

# (functions.sh) Ensures that fuse is set correct for rclone
rcpiece

sudocheck
clonestart
