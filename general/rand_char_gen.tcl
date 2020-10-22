# rand_char_gen.tcl
#
#   The original script was discovered on the following site:
#   https://wiki.tcl-lang.org/page/Generating+random+strings
#   The modification made to the script is to include the full
#   alphabet and numerical digit range.

proc lpick L {lindex $L [expr {int(rand()*[llength $L])}]}
proc randomlyPicked { length {chars {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9}} } {
    for {set i 0} {$i<$length} {incr i} {append res [lpick $chars]}
    return $res
}

puts [randomlyPicked 24]