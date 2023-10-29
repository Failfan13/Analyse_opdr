#!/usr/bin/env bash

# Define global variable here
config_file="config.conf"

# Declared dependancies
declare -a dependancies=("unzip" "wget" "curl")

# Added necessary packages
declare -a packages=("")

# Error handling function with 2 passable arguments
function handle_error() {
    # Do not remove next line!
    echo "function handle_error"

    #Display the given error code
    echo -e "Error: $1"

    #On error executable
    eval "$2"

    #Exit script
    exit 1
}
 
# Function to solve dependencies
function setup() {
    # Do not remove next line!
    echo "function setup"
    
# Checks each dependency in $dependancies
    for pkg in "${dependancies[@]}"; do
        echo "Checking dependency: $pkg"
        check_dependency "$pkg"
    done

    # TODO check if nessassary dependecies and folder structure exists and 
    # print the outcome for each checking step
    
    # TODO installation from online package requires values for
    # package_name package_url install_dir

    # TODO check if required dependency is not already installed otherwise install it
    # if a a problem occur during the this process 
    # use the function handle_error() to print a messgage and handle the error

# Checking the file & folder structure
    echo "Checking folder structure"

    if [ ! -d "./apps/" ]; then
        echo "Creating apps folder"
        mkdir ./apps/
    elif [ ! -f "dev.conf" ]; then
        handle_error "Missing dev.conf file"
    elif [ ! -f "test.json" ]; then
        handle_error "Missing test.json"
    fi
}

# Function to install a package from a URL
# TODO assign the required parameter needed for the logic
# complete the implementation of the following function.
function install_package() {
    # Do not remove next line!
    echo "function install_package"

    setup

    # TODO The logic for downloading from a URL and unizpping the downloaded files of different applications must be generic

    # TODO Specific actions that need to be taken for a specific application during this process should be handeld in a separate if-else

    # TODO Every intermediate steps need to be handeld carefully. error handeling should be dealt with using handle_error() and/or rolleback()

    # TODO If a file is downloaded but cannot be zipped a rollback is needed to be able to start from scratch
    # for example: package names and urls that are needed are passed or extracted from the config file

    # TODO check if the application-folder and the url of the dependency exist
    # TODO create a specific installation folder for the current package

    # TODO Download and unzip the package
    # if a a problem occur during the this proces use the function handle_error() to print a messgage and handle the error

    # TODO extract the package to the installation folder and store it into a dedicated folder
    # If a problem occur during the this proces use the function handle_error() to print a messgage and handle the error

    # TODO this section can be used to implement application specifc logic
    # nosecrets might have additional commands that needs to be executed
    # make sure the user is allowed to remove this folder during uninstall

}

function rollback_nosecrets() {
    # Do not remove next line!
    echo "function rollback_nosecrets"

    # TODO rollback intermiediate steps when installation fails
}

function rollback_pywebserver() {
    # Do not remove next line!
    echo "function rollback_pywebserver"

    # TODO rollback intermiediate steps when installation fails
}

function test_nosecrets() {
    # Do not remove next line!
    echo "function test_nosecrets"

    # TODO test nosecrets
    # kill this webserver process after it has finished its job

}

function test_pywebserver() {
    # Do not remove next line!
    echo "function test_pywebserver"    

    # TODO test the webserver
    # server and port number must be extracted from config.conf
    # test data must be read from test.json  
    # kill this webserver process after it has finished its job

}

function uninstall_nosecrets() {
    # Do not remove next line!
    echo "function uninstall_nosecrets"  

    #TODO uninstall nosecrets application
}

function uninstall_pywebserver() {
    echo "function uninstall_pywebserver"    
    #TODO uninstall pywebserver application
}

#TODO removing installed dependency during setup() and restoring the folder structure to original state
function remove() {
    # Do not remove next line!
    echo "function remove"

    # Remove each package that was installed during setup

}

function main() {
    # Do not remove next line!
    echo "function main"

# Verify supplied commands is 1 atleast
    if [ $# -lt 1 ]; then
        handle_error "No command supplied"
    fi

# Command and action given at excecution of script
    command="$1"
    action="$2"

# Format command(up/low) and action in particular style
    command_formatted_up="${command^^}"
    command_formatted_low="${command,,}"
    action_formatted="${action^^}"

# Verify command is available and run attachted function
    case $command_formatted_up in
        "SETUP")
            setup
            ;;
        "NOSECRETS" | "PYWEBSERVER")
# Add options for "install, uninstall and test"
            if [ "$action_formatted" = "--INSTALL" ];then
                echo $command_formatted_low"--install"
            elif [ "$action_formatted" = "--UNINSTALL" ]; then
                echo $command_formatted_low"--uninstall"
            elif [ "$action_formatted" = "--TEST" ]; then
                echo $command_formatted_low"--test"
            else
                handle_error "Could not find accompanied action\nexiting..."
            fi
            ;;
        "REMOVE")
                remove
            ;;
        *)    
            handle_error "Could not find accompanied command\nexiting..."
        ;;
    esac

    # Execute the appropriate command based on the arguments
    # TODO In case of setup
    # excute the function check_dependency and provide necessary arguments
    # expected arguments are the installation directory specified in dev.conf
}

# Dependency checker arguments "package_name", "(true/false) auto install"
function check_dependency() {
# Find dependency by name in installed packages and save the Status
    installed=$(dpkg-query -W -f='${Status}' "$1")

# If status installed found and return, otherwise provide installation instructions
    if [ "$installed" = "install ok installed" ]; then
        echo -e "Found and installed\n"
        return
    fi

# Recursion for checking installed dependency
    echo -e "Missing dependency, trying to install\n"
    if [ "$2" != false ]; then
        "$(sudo apt-get install "$1")"
        check_dependency "$1" false
    else
        handle_error "$1 not found/installed, To install please use: sudo apt install $1\n"
    fi
}

# Pass commandline arguments to function main
main "$@"