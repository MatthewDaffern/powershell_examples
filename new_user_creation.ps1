$file_location = out-host 'please enter the file location of your user list'
$Users = Import-CSV $file_location

# need to convert this all to functions. 

function chr_gen{
    $chr = ([char](get-random -max 128))
    return $chr
}


function password_creator($length, $chr_randomizer){
    $password = $null
    1.. $length | & $chr_randomizer >> $password
    return $password
}

#got to figure out a map implementation. tracking state internally isn't so bad, but kinda lame tbh when you're just trying to keep it simple.
function map($function, $iterable){
    $old_iterable = $iterable
    $new_iterable = @()
    foreach ($item in $old_iterable){   
        & $function($item) >> $new_iterable
    }
    return $new_iterable
}


#setting functions as variables requires scoping the variable to be a function.
#$foo1 = $function:foo
#then it's called with &

function create_user($user){
    $Username= $user.Username
    $password = password_creator(15, function:chr_gen)
    New-ADUser
    -UserPrincipalName $user.email `
    -SamAccountName $user.Username `
    -UserPrincipalName "$Username@yourdomain.com" `
    -Name "$user.Firstname $user.Lastname" `
    -GivenName $user.Firstname `
    -Surname $user.Lastname `
    -Enabled $True `
    -ChangePasswordAtLogon $True `
    -DisplayName "$user.Lastname, $user.Firstname" `
    -Department $Department `
    -Path $OU `
    -AccountPassword (convertto-securestring $password -AsPlainText -Force)
    return $username + ',' + $password
}


function csv_to_array($csv_input){
    $converted_array = ConvertFrom-Csv -path $csv_input
    return $converted_array
}

map($function:create_user, csv_to_array(read-host 'where is the csv file?'))