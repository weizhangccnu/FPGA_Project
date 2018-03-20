proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7k325tffg900-2
  set_property board_part xilinx.com:kc705:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.cache/wt [current_project]
  set_property parent.project_path /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.xpr [current_project]
  set_property ip_repo_paths /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.cache/ip [current_project]
  set_property ip_output_repo /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.cache/ip [current_project]
  set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.runs/synth_1/kc705_mig.dcp
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz.dcp
  set_property netlist_only true [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz.dcp]
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/sources_1/ip/vio_0/vio_0.dcp
  set_property netlist_only true [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/sources_1/ip/vio_0/vio_0.dcp]
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/tri_mode_ethernet_mac_0.dcp
  set_property netlist_only true [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/tri_mode_ethernet_mac_0.dcp]
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32.dcp
  set_property netlist_only true [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32.dcp]
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8.dcp
  set_property netlist_only true [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8.dcp]
  add_files -quiet /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512.dcp
  set_property netlist_only true [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512.dcp]
  read_xdc -ref dbg_ila -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/dbg_ila/ila_v6_1/constraints/ila.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/dbg_ila/ila_v6_1/constraints/ila.xdc]
  read_xdc -mode out_of_context -ref clockwiz -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz_ooc.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clockwiz -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz_board.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz_board.xdc]
  read_xdc -ref clockwiz -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz.xdc]
  read_xdc -mode out_of_context -ref vio_0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/sources_1/ip/vio_0/vio_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/sources_1/ip/vio_0/vio_0_ooc.xdc]
  read_xdc -ref vio_0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/sources_1/ip/vio_0/vio_0.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/sources_1/ip/vio_0/vio_0.xdc]
  read_xdc -mode out_of_context -ref tri_mode_ethernet_mac_0 -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_ooc.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref tri_mode_ethernet_mac_0 -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_board.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_board.xdc]
  read_xdc -ref tri_mode_ethernet_mac_0 -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0.xdc]
  read_xdc -mode out_of_context -ref fifo8to32 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32_ooc.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32_ooc.xdc]
  read_xdc -ref fifo8to32 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32/fifo8to32.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32/fifo8to32.xdc]
  read_xdc -mode out_of_context -ref fifo32to8 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8_ooc.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8_ooc.xdc]
  read_xdc -ref fifo32to8 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8/fifo32to8.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8/fifo32to8.xdc]
  read_xdc -mode out_of_context -ref fifo36x512 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512_ooc.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512_ooc.xdc]
  read_xdc -ref fifo36x512 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512/fifo36x512.xdc
  set_property processing_order EARLY [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512/fifo36x512.xdc]
  read_xdc /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/constrs_1/new/top_KC705.xdc
  read_xdc /home/weizhang/Desktop/FPGA_Project/kc705_mig/kc705_mig.srcs/constrs_1/new/FMC_kc705_mig.xdc
  read_xdc -ref clockwiz -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz_late.xdc
  set_property processing_order LATE [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/clockwiz/clockwiz_late.xdc]
  read_xdc -ref tri_mode_ethernet_mac_0 -cells inst /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_clocks.xdc
  set_property processing_order LATE [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/tri_mode_ethernet_mac_0/synth/tri_mode_ethernet_mac_0_clocks.xdc]
  read_xdc -ref fifo8to32 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32/fifo8to32_clocks.xdc
  set_property processing_order LATE [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo8to32/fifo8to32/fifo8to32_clocks.xdc]
  read_xdc -ref fifo32to8 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8/fifo32to8_clocks.xdc
  set_property processing_order LATE [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo32to8/fifo32to8/fifo32to8_clocks.xdc]
  read_xdc -ref fifo36x512 -cells U0 /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512/fifo36x512_clocks.xdc
  set_property processing_order LATE [get_files /home/weizhang/Desktop/FPGA_Project/kc705_mig/ipcore_dir/fifo36x512/fifo36x512/fifo36x512_clocks.xdc]
  link_design -top kc705_mig -part xc7k325tffg900-2
  write_hwdef -file kc705_mig.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force kc705_mig_opt.dcp
  report_drc -file kc705_mig_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force kc705_mig_placed.dcp
  report_io -file kc705_mig_io_placed.rpt
  report_utilization -file kc705_mig_utilization_placed.rpt -pb kc705_mig_utilization_placed.pb
  report_control_sets -verbose -file kc705_mig_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force kc705_mig_routed.dcp
  report_drc -file kc705_mig_drc_routed.rpt -pb kc705_mig_drc_routed.pb
  report_timing_summary -warn_on_violation -max_paths 10 -file kc705_mig_timing_summary_routed.rpt -rpx kc705_mig_timing_summary_routed.rpx
  report_power -file kc705_mig_power_routed.rpt -pb kc705_mig_power_summary_routed.pb -rpx kc705_mig_power_routed.rpx
  report_route_status -file kc705_mig_route_status.rpt -pb kc705_mig_route_status.pb
  report_clock_utilization -file kc705_mig_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force kc705_mig.mmi }
  write_bitstream -force kc705_mig.bit 
  catch { write_sysdef -hwdef kc705_mig.hwdef -bitfile kc705_mig.bit -meminfo kc705_mig.mmi -file kc705_mig.sysdef }
  catch {write_debug_probes -quiet -force debug_nets}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

