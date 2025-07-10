
/*-----------------------------------------------------------------
File name     : reset_test.sv
Developers    : Lisa Barbay, Brian Dickinson
Created       : 7/11/12
Description   : This file calls the built-in reset test
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2012 
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// CLASS: uvm_reset_test
//-----------------------------------------------------------------------------

class  uvm_reset_test extends base_test;



    uvm_reg_hw_reset_seq reset_seq;

  // component macro
  `uvm_component_utils(uvm_reset_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
     
  endtask

endclass : uvm_reset_test



/*

// reg_function_test
class  reg_function_test extends base_test;
    	yapp_tx_sequencer yapp_seqncr;
	yapp_012_seq yapp_012;
    	yapp_regs_c yapp_reg;
    	uvm_status_e status;
  // component macro
  `uvm_component_utils(reg_function_test)
  
  bit [7:0] rdata, count_addr0, count_addr1, count_addr2, count_addr3;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      yapp_012 = yapp_012_seq::type_id::create("yapp_012");
      super.build_phase(phase);
      uvm_config_wrapper::set(this,"inst_tb.clk_and_rst.agent.sequencer.run_phase","default_sequence",clk10_rst5_seq::get_type());
      uvm_config_wrapper::set(this,"inst_tb.channel_?.*rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::get_type());
  endfunction : build_phase
  
  virtual function void connect_phase(uvm_phase phase);
  	yapp_reg = inst_tb.yapp_rm.router_yapp_regs;
  	yapp_seqncr = inst_tb.yapp_uvc.agent.sequencer;
  endfunction : connect_phase
  
  // Functional Verification
  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     
     inst_tb.yapp_rm.default_map.set_check_on_read(1);
    
     yapp_reg.en_reg.write(status, 1'b1);
     yapp_reg.en_reg.read(status, rdata);
     Front_Door_Write_in_RW_reg: assert (rdata ==  8'h01)
     `uvm_info(get_type_name(),"Router Enabled",UVM_NONE)
     else
     `uvm_info(get_type_name(),"Router Not Enabled",UVM_NONE);
       
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     // yapp_reg.model = inst_tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
  
     yapp_012.start(yapp_seqncr);
     
    
     yapp_reg.addr0_cnt_reg.read(status, count_addr0);
     yapp_reg.addr1_cnt_reg.read(status, count_addr1);
     yapp_reg.addr2_cnt_reg.read(status, count_addr2);
     yapp_reg.addr3_cnt_reg.read(status, count_addr3);
     
     `uvm_info(get_type_name(),"\n\n*** All the address counts should be zero *** ",UVM_NONE)
     `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE); 
     `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);    
     `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);    
     `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n\n",count_addr3),UVM_NONE); 
     
     yapp_reg.en_reg.write(status, 8'hFF);
     
     repeat(2)
	     begin
     		 yapp_012.start(yapp_seqncr);
	     end
    
     yapp_reg.addr0_cnt_reg.predict(1);
     yapp_reg.addr0_cnt_reg.read(status, count_addr0);
     yapp_reg.addr1_cnt_reg.predict(1);
     yapp_reg.addr1_cnt_reg.read(status, count_addr1);
     yapp_reg.addr2_cnt_reg.predict(1);
     yapp_reg.addr2_cnt_reg.read(status, count_addr2);
     yapp_reg.addr3_cnt_reg.predict(1);
     yapp_reg.addr3_cnt_reg.read(status, count_addr3);
     `uvm_info(get_type_name(),"\n\n *** All the address counts should be incremented *** ",UVM_NONE)
     `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
     `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);  
     `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);  
     `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n",count_addr3),UVM_NONE); 
     
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
          
  endtask
  
/*  
	// Functional Verification
  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     
     yapp_reg.en_reg.write(status, 1'b1);
     yapp_reg.en_reg.read(status, rdata);
     Front_Door_Write_in_RW_reg: assert (rdata ==  8'h01)
     `uvm_info(get_type_name(),"Router Enabled",UVM_NONE)
     else
     `uvm_info(get_type_name(),"Router Not Enabled",UVM_NONE);
       
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     // yapp_reg.model = inst_tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     
     yapp_012.start(yapp_seqncr);
     
     `uvm_info(get_type_name(),"\n\n*** All the address counts should be zero *** ",UVM_NONE)
     yapp_reg.addr0_cnt_reg.read(status, rdata);
     `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",rdata),UVM_NONE);
      yapp_reg.addr1_cnt_reg.read(status, rdata);
     `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",rdata),UVM_NONE);
      yapp_reg.addr2_cnt_reg.read(status, rdata);
     `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",rdata),UVM_NONE);
      yapp_reg.addr3_cnt_reg.read(status, rdata);
     `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n\n",rdata),UVM_NONE); 
     
     yapp_reg.en_reg.write(status, 8'hFF);
     
     repeat(2)
	     begin
     		 yapp_012.start(yapp_seqncr);
	     end
     
     `uvm_info(get_type_name(),"\n\n *** All the address counts should be incremented *** ",UVM_NONE)
     yapp_reg.addr0_cnt_reg.read(status, count_addr0);
     yapp_reg.addr1_cnt_reg.read(status, count_addr1);
     yapp_reg.addr2_cnt_reg.read(status, count_addr2);
     yapp_reg.addr3_cnt_reg.read(status, count_addr3);
     `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
     `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);  
     `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);  
     `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n",count_addr3),UVM_NONE); 
     
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
          
  endtask
endclass : reg_function_test
*/