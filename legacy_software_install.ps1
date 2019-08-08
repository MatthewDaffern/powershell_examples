function csv_importer($input_path){
    $list_of_programs = Import-Csv -Path $input_path
    return $list_of_programs
}

function software_install($software_information, $target_computer){
    #copy the software to the target computer
    Invoke-Command {Copy-Item -Path $software_information.source -Destination $target_computer.temp_folder}
    Invoke-Command {Start-Process ($target_computer.temp_folder + $software_information.file_name) }
    #after some googling, looks like this has to have some work before I can just programatically install software without knowing the quiet switch.
}

function map($function, $iterable){
    $new_list = @()
    foreach ($item in $iterable){
        & $function($item) >> $new_list
    }
    return $new_list
}

# https://devblogs.microsoft.com/scripting/proxy-functions-spice-up-your-powershell-core-cmdlets/
# use proxy functions to help with multi-parameter functions.

