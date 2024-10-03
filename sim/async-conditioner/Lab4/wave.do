onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /led_patterns_tb/clk_tb
add wave -noupdate /led_patterns_tb/rst_tb
add wave -noupdate /led_patterns_tb/push_button_tb
add wave -noupdate /led_patterns_tb/switches_tb
add wave -noupdate /led_patterns_tb/hps_led_control_tb
add wave -noupdate /led_patterns_tb/base_period_tb
add wave -noupdate /led_patterns_tb/led_reg_tb
add wave -noupdate /led_patterns_tb/led_tb
add wave -noupdate /led_patterns_tb/dut/current_state
add wave -noupdate /led_patterns_tb/dut/next_state
add wave -noupdate /led_patterns_tb/dut/global_done
add wave -noupdate /led_patterns_tb/dut/half_base_rate_counter/done
add wave -noupdate /led_patterns_tb/dut/base_period_done
add wave -noupdate /led_patterns_tb/dut/global_enable
add wave -noupdate /led_patterns_tb/dut/double_base_rate_counter/count_time
add wave -noupdate /led_patterns_tb/dut/half_base_rate_counter/count_time
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2396993318 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 397
configure wave -valuecolwidth 212
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
WaveRestoreZoom {9999249849 ps} {10000039482 ps}
