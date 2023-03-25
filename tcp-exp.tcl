set opt(chan)           Channel/WirelessChannel  ;
set opt(prop)           Propagation/TwoRayGround ;
set opt(netif)          Phy/WirelessPhy          ;
set opt(mac)            Mac/802_11               ;
set opt(ifq)            Queue/DropTail/PriQueue  ;
set opt(ll)             LL                       ;
set opt(ant)            Antenna/OmniAntenna      ;
set opt(ifqlen)         50                       ;
set opt(bottomrow)      9                        ;
set opt(adhocRouting)   AODV                     ;
set opt(x)              700                      ;
set opt(y)              700                      ;
set opt(finish)         100                      ;
$opt(mac) set RTSThreshold_ 5000;
Mac/802_11 set basicRate_ 1Mb;
Mac/802_11 set dataRate_  55Mb;

set ns [new Simulator]

set name [lindex [split [info script] "."] 0]
$ns use-newtrace
set tracefd  [open $name.tr w]
set namtrace [open $name.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $opt(x) $opt(y)

set topo [new Topography]

$topo load_flatgrid $opt(x) $opt(y)

create-god [expr $opt(bottomrow)]

set chan1 [new $opt(chan)]

proc UniformErr {} {
	set err [new ErrorModel]
    $err set rate_ 0.000001
	$err unit packet
	return $err
}

$ns node-config -adhocRouting $opt(adhocRouting) \
    -llType $opt(ll) \
    -macType $opt(mac) \
    -ifqType $opt(ifq) \
    -ifqLen $opt(ifqlen) \
    -antType $opt(ant) \
    -propType $opt(prop) \
    -phyType $opt(netif) \
    -channel $chan1 \
    -topoInstance $topo \
    -IncomingErrProc UniformErr \
    -OutgoingErrProc UniformErr \
    -wiredRouting OFF \
    -agentTrace ON \
    -routerTrace ON \
    -macTrace OFF

set A [$ns node]
set D [$ns node]
set B [$ns node]
set C [$ns node]
set E [$ns node]
set F [$ns node]
set G [$ns node]
set H [$ns node]
set L [$ns node]

$A set X_ 200.0
$A set Y_ 400.0
$A set Z_ 0.0

$B set X_ 100.0
$B set Y_ 200.0
$B set Z_ 0.0

$C set X_ 300.0
$C set Y_ 275.0
$C set Z_ 0.0

$D set X_ 200.0
$D set Y_ 0.0
$D set Z_ 0.0

$E set X_ 300.0
$E set Y_ 125.0
$E set Z_ 0.0

$F set X_ 450.0
$F set Y_ 125.0
$F set Z_ 0.0

$G set X_ 450.0
$G set Y_ 275.0
$G set Z_ 0.0

$H set X_ 600.0
$H set Y_ 275.0
$H set Z_ 0.0

$L set X_ 600.0
$L set Y_ 125.0
$L set Z_ 0.0

set tcp1 [new Agent/TCP]
$ns attach-agent $A $tcp1
set ftp1 [new Application/FTP]
$ftp1 set packetSize_ 10000
$ftp1 set rate_ 200Kb
$ftp1 attach-agent $tcp1

set tcp11 [new Agent/TCP]
$ns attach-agent $A $tcp11
set ftp11 [new Application/FTP]
$ftp11 set packetSize_ 10000
$ftp11 set rate_ 200Kb
$ftp11 attach-agent $tcp11

set tcp2 [new Agent/TCP]
$ns attach-agent $D $tcp2
set ftp2 [new Application/FTP]
$ftp2 set packetSize_ 10000
$ftp2 set rate_ 200Kb
$ftp2 attach-agent $tcp2

set tcp22 [new Agent/TCP]
$ns attach-agent $D $tcp22
set ftp22 [new Application/FTP]
$ftp22 set packetSize_ 10000
$ftp22 set rate_ 200Kb
$ftp22 attach-agent $tcp22


set sink1 [new Agent/TCPSink]
$ns attach-agent $H $sink1
set sink11 [new Agent/TCPSink]
$ns attach-agent $H $sink11
set sink2 [new Agent/TCPSink]
$ns attach-agent $L $sink2
set sink22 [new Agent/TCPSink]
$ns attach-agent $L $sink22

$ns connect $tcp1 $sink1
$ns connect $tcp11 $sink2
$ns connect $tcp2 $sink11
$ns connect $tcp22 $sink22

$ns at 0 "$ftp1 start"
$ns at 0 "$ftp2 start"
$ns at 0 "$ftp11 start"
$ns at 0 "$ftp22 start"
$ns at $opt(finish) "$ftp1 stop"
$ns at $opt(finish) "$ftp2 stop"
$ns at $opt(finish) "$ftp11 stop"
$ns at $opt(finish) "$ftp22 stop"

$ns initial_node_pos $A 20.0
$ns initial_node_pos $B 20.0
$ns initial_node_pos $C 20.0
$ns initial_node_pos $D 20.0
$ns initial_node_pos $E 20.0
$ns initial_node_pos $F 20.0
$ns initial_node_pos $G 20.0
$ns initial_node_pos $H 20.0
$ns initial_node_pos $L 20.0

$A color blue
$ns at 0.0 "$A color blue"
$D color blue
$ns at 0.0 "$D color blue"
$L color red
$ns at 0.0 "$L color red"
$H color red
$ns at 0.0 "$H color red"


$ns at $opt(finish) "finish"

proc finish {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec nam tcp-exp.nam &
    exec python3 ./utility/parser.py &
    exit 0
}

$ns run
