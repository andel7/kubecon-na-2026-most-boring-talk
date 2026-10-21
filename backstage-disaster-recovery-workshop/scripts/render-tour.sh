#!/usr/bin/env bash
# Writes .tours/backstage-dr.tour from tours/backstage-dr.tour.tmpl. CodeTour reads tours from
# .tours/ in the workspace folder. Fills in:
#   {{BASE_URL}}, {{BASE_URL_ARG}}   the portal URL, known only at runtime (the second one
#                                    URL-encoded as the Simple Browser command's argument)
#   "{{LINE:<file>:<regex>}}"        the line number of the first line in <file> matching <regex>,
#                                    so steps stay anchored when the files change
source "$(dirname "$0")/lib.sh"

url="$(base_url)"
url_arg="$(jq -rn --arg u "${url}" '[$u] | tojson | @uri')"

mkdir -p "${ROOT_DIR}/.tours"
cd "${ROOT_DIR}"
URL="${url}" URL_ARG="${url_arg}" perl -pe '
  s/\{\{BASE_URL\}\}/$ENV{URL}/g;
  s/\{\{BASE_URL_ARG\}\}/$ENV{URL_ARG}/g;
  s{"\{\{LINE:([^:]+):(.+?)\}\}"}{
    my ($file, $re) = ($1, $2); my $n = 0; my $found;
    open(my $fh, "<", $file) or die "render-tour: no file $file\n";
    while (<$fh>) { $n++; if (/$re/) { $found = $n; last } }
    defined $found or die "render-tour: no line matching /$re/ in $file\n";
    $found
  }ge;
' tours/backstage-dr.tour.tmpl >.tours/backstage-dr.tour.partial
mv .tours/backstage-dr.tour.partial .tours/backstage-dr.tour
