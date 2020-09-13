#!/usr/bin/env bash
source /opt/mhs/lib/traefik/functions.sh

traefikstart() {

  traefikpaths  #functions
  traefikstatus #functions
  layoutbuilder # functions - builds out menu

  case $typed in
    1) bash /opt/mhs/lib/traefik/tld.sh && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    2) providerinterface && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    3) domaininterface && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    4) emailinterface && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    5) delaycheckinterface && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    a) blockdeploycheck && deploytraefik && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    A) blockdeploycheck && deploytraefik && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    B) destroytraefik && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    b) destroytraefik && bash /opt/mhs/lib/traefik/traefik.sh && exit ;;
    z) exit ;;
    Z) exit ;;
    *) traefikstart ;;
  esac

}

main /var/mhs/state/traefik.provider NOT-SET provider
main /var/mhs/state/server.email NOT-SET email
main /var/mhs/state/server.delaycheck 60 delaycheck
main /var/mhs/state/server.domain NOT-SET domain
main /var/mhs/state/tld.program NOT-SET tld
main /var/mhs/state/traefik.deploy 'Not Deployed' deploy

traefikstart
