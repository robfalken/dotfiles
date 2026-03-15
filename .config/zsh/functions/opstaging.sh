opstaging() {
    local current_dir="$PWD"
    local env_file=""

    # Traverse up the directory tree looking for .env.staging
    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/.env.staging" ]]; then
            env_file="$current_dir/.env.staging"
            break
        fi
        current_dir="$(dirname "$current_dir")"
    done

    if [[ -z "$env_file" ]]; then
        echo "Error: .env.staging not found in current directory or any parent directory"
        return 1
    fi

    op run --no-masking --env-file "$env_file" -- "$@"
}
