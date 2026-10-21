#!/usr/bin/env bash
# Writes .tours/backstage-dr.tour from tours/backstage-dr.tour.tmpl, with the portal URL filled in.
# CodeTour reads tours from .tours/ in the workspace folder.
source "$(dirname "$0")/lib.sh"

url="$(base_url)"
# The Simple Browser command link carries the URL as a URL-encoded JSON argument.
url_arg="$(jq -rn --arg u "${url}" '[$u] | tojson | @uri')"

mkdir -p "${ROOT_DIR}/.tours"
URL="${url}" URL_ARG="${url_arg}" perl -pe 's/\{\{BASE_URL\}\}/$ENV{URL}/g; s/\{\{BASE_URL_ARG\}\}/$ENV{URL_ARG}/g' \
  "${ROOT_DIR}/tours/backstage-dr.tour.tmpl" >"${ROOT_DIR}/.tours/backstage-dr.tour"
