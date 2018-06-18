onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/apb_intf/cb/cb_event
add wave -noupdate /tb_top/apb_intf/PRESETn
add wave -noupdate /tb_top/apb_intf/PSEL
add wave -noupdate /tb_top/apb_intf/PENABLE
add wave -noupdate /tb_top/apb_intf/PREADY
add wave -noupdate /tb_top/apb_intf/PWRITE
add wave -noupdate /tb_top/apb_intf/PADDR
add wave -noupdate /tb_top/apb_intf/PWDATA
add wave -noupdate /tb_top/apb_intf/PRDATA
add wave -noupdate /tb_top/apb_intf/PSLVERR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 220
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {339851165256 ps}
