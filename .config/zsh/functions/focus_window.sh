#!/usr/bin/env zsh

focus_window() {
    local app_bundle_id="${1}"

    # Check if app_bundle_id is provided
    if [[ -z "$app_bundle_id" ]]; then
        echo "Error: app_bundle_id is required" >&2
        return 1
    fi

    local result
    result=$(aerospace list-windows --all --format "%{window-id} %{app-bundle-id}" | grep "$app_bundle_id")
    echo "$result"

    if [[ -n "$result" ]]; then
        echo "$result" |  awk '{print "aerospace focus --window-id " $1}' | sh
    else
        open -b "$app_bundle_id"
    fi
}
