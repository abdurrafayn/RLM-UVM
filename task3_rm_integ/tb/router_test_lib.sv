class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    function new(string name="base_test", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    router_tb inst_tb;

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());

        // inst_tb = new("inst_tb", this);
        inst_tb = router_tb::type_id::create("inst_tb", this);
        uvm_config_int::set( this, "*", "recording_detail", 1);
        `uvm_info("test_phase","Build phase of test is executing", UVM_HIGH);
    endfunction: build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

        function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Running Simulation in Test class", UVM_HIGH);
        
    endfunction

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection(); 
        obj.set_drain_time(this, 200ns);

    endtask

    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction
endclass //className extends superClass



// class  uvm_mem_walk_test extends base_test;


//    uvm_mem_walk_seq reset_seq;

//   // component macro
//   `uvm_component_utils(uvm_mem_walk_test)

//   // component constructor
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//   endfunction : new

//   function void build_phase(uvm_phase phase);
//       uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
//       reset_seq = uvm_mem_walk_seq::type_id::create("uvm_reset_seq");
//       super.build_phase(phase);

//                uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                                 "default_sequence", null);

//         uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
//                        "default_sequence", clk10_rst5_seq::get_type());
//   endfunction : build_phase

//   virtual task run_phase (uvm_phase phase);
//      phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
//      // Set the model property of the sequence to our Register Model instance
//      // Update the RHS of this assignment to match your instance names. Syntax is:
//      //  <testbench instance>.<register model instance>
//      reset_seq.model = inst_tb.yapp_rm;
//      // Execute the sequence (sequencer is already set in the testbench)
//      reset_seq.start(null);
//      phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
     
//   endtask

// endclass : uvm_mem_walk_test



// class reg_access_test extends base_test;

//     int rdata;


//     yapp_regs_c yapp_regs;
//     uvm_status_e status;

//     // component macro
//   `uvm_component_utils(reg_access_test)

//   // component constructor
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//   endfunction : new

//   function void build_phase(uvm_phase phase);
//       uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
//      // reset_seq = reg_access_test::type_id::create("uvm_reset_seq");
//       super.build_phase(phase);

//         uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                                 "default_sequence", null);

//         uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
//                        "default_sequence", clk10_rst5_seq::get_type());
//   endfunction : build_phase

//   virtual task run_phase (uvm_phase phase);
//     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
//         yapp_regs.en_reg.write(status, 8'hA5); // Front-door write a unique value
//         yapp_regs.en_reg.peek(status, rdata); // Peek and check the DUT value matches the written value.
//         `uvm_info("get_type_name()", $sformatf("Read value from en_reg: %0h", rdata), UVM_LOW);
//         //assert(rdata == 8'hA5) else `uvm_info(get_type_name(), $sformatf("RW TEST: Data Read is %h", rdata), UVM_LOW);

//         yapp_regs.en_reg.poke(status, 8'h5A); // poke a new value to the register
//         yapp_regs.en_reg.read(status, rdata); // Front-door read the new value and check it matches.
//         `uvm_info("get_type_name()", $sformatf("Read value from en_reg: %0h", rdata), UVM_LOW);
//         //assert(rdata == 8'h5A) else `uvm_info(get_type_name(), $sformatf("RW TEST: Data Read is %h", rdata), UVM_LOW);
        


//         // RO
//         yapp_regs.addr0_cnt_reg.poke(status, 8'hA5); //Poke a unique value.
//         yapp_regs.addr0_cnt_reg.read(status, rdata); // Front-door read and check the value matches
//         `uvm_info("get_type_name()", $sformatf("Read value from addr0_cnt_reg: %0h", rdata), UVM_LOW);

//         yapp_regs.addr0_cnt_reg.write(status, 8'h5A); //Front-door write a new value
//         yapp_regs.addr0_cnt_reg.peek(status, rdata); //Peek and check the DUT value has not changed
//         `uvm_info("get_type_name()", $sformatf("Read value from addr0_cnt_reg: %0h", rdata), UVM_LOW);

//      phase.drop_objection(this," Dropping Objection to uvm built reset test finished");     
//   endtask

//   function void connect_phase(uvm_phase phase);

//     yapp_regs = inst_tb.yapp_rm.router_yapp_regs;

//     endfunction: connect_phase

// endclass: reg_access_test


class reg_function_test extends base_test;

    int rdata, count_addr0, count_addr1, count_addr2, count_addr3;


    yapp_tx_sequencer yapp_sequencer;
    yapp_012_packets yapp_012_seq;
    yapp_regs_c yapp_regs;
    uvm_status_e status;

  `uvm_component_utils(reg_function_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      yapp_012_seq = yapp_012_packets::type_id::create("yapp_012_seq");

     // reset_seq = reg_access_test::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
        uvm_config_wrapper::set(this, "inst_tb.channel_?.rx_agent.sequencer.run_phase",
                                "default_sequence", channel_rx_resp_seq::get_type());

        uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
                                "default_sequence", null);

        uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
                       "default_sequence", clk10_rst5_seq::get_type());
  endfunction : build_phase


  function void connect_phase(uvm_phase phase);

    yapp_regs = inst_tb.yapp_rm.router_yapp_regs;
    yapp_sequencer = inst_tb.environment.agent.sequencer;

    endfunction: connect_phase
  
  
  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
            
            yapp_regs.en_reg.write(status, 1'b1);
            yapp_regs.en_reg.read(status, rdata);
            
            yapp_012_seq.start(yapp_sequencer);

            // yapp_regs.addr0_cnt_reg.read(status, count_addr0);
            // yapp_regs.addr1_cnt_reg.read(status, count_addr1);
            // yapp_regs.addr2_cnt_reg.read(status, count_addr2);
            // yapp_regs.addr3_cnt_reg.read(status, count_addr3);

            // `uvm_info(get_type_name(),"\n\n*** they have not been incremented*** ",UVM_NONE)
            // `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
            // `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);
            // `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);
            // `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n\n",count_addr3),UVM_NONE);

            yapp_regs.en_reg.write(status, 8'hff);
            repeat(2)
                begin
                    yapp_012_seq.start(yapp_sequencer);
                end
            // yapp_regs.en_reg.predict(status,8'hff);
            // yapp_regs.addr0_cnt_reg.predict(8'h02);
            // yapp_regs.addr1_cnt_reg.predict(8'h02);
            // yapp_regs.addr2_cnt_reg.predict(8'h02);
            // yapp_regs.addr3_cnt_reg.predict(8'h00);

            // `uvm_info(get_type_name(),"\n\n *** All the address counts should be incremented *** ",UVM_NONE)
            // `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
            // `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);
            // `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);
            // `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n",count_addr3),UVM_NONE);


     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");     
  endtask

endclass

// Introspect Test



class introspect_test extends base_test;

  // int rdata; count_addr0, count_addr1, count_addr2, count_addr3;
  int rdata;

    yapp_tx_sequencer yapp_sequencer;
    yapp_012_packets yapp_012_seq;
    yapp_regs_c yapp_regs;
    uvm_status_e status;

    uvm_reg qreg[$], rwregs[$], roregs[$];

    `uvm_component_utils(introspect_test)

    function new(string name="introspect_test", uvm_component parent);
        super.new(name, parent);
    endfunction //new()


    function void connect_phase(uvm_phase phase);

      yapp_regs = inst_tb.yapp_rm.router_yapp_regs;
      yapp_sequencer = inst_tb.environment.agent.sequencer;

    endfunction: connect_phase
       
    function void build_phase(uvm_phase phase);
       
      super.build_phase(phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      
      yapp_regs= yapp_regs_c::type_id::create("yapp_regs");
      yapp_012_seq = yapp_012_packets::type_id::create("yapp_012_seq");

     // reset_seq = reg_access_test::type_id::create("uvm_reset_seq");
        uvm_config_wrapper::set(this, "inst_tb.channel_?.rx_agent.sequencer.run_phase",
                                "default_sequence", channel_rx_resp_seq::get_type());

        uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
                                "default_sequence", null);

        uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
                       "default_sequence", clk10_rst5_seq::get_type());
    
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        phase.raise_objection(this, "Running introspection test");
            
            yapp_regs.get_registers(qreg);

            foreach(qreg[i]) begin

              if(qreg[i].get_rights() == "RO") begin
                roregs.push_back(qreg[i]);
                `uvm_info(get_type_name(), $sformatf("Read_Only Register Name =  %s",qreg[i].get_name()), UVM_NONE)
              end
            end

                rwregs = qreg.find(i) with (i.get_rights()== "RW");
                foreach(rwregs[i]) begin
                    `uvm_info(get_type_name(), $sformatf("Read_Write Register Name =  %s",rwregs[i].get_name()), UVM_NONE)
                end

            yapp_regs.en_reg.write(status, 1'b1);
            yapp_regs.en_reg.read(status, rdata);

            `uvm_info(get_type_name(), $sformatf("en_reg after write: 0x%0h", rdata), UVM_LOW);

            
            yapp_012_seq.start(yapp_sequencer);

            yapp_regs.en_reg.write(status, 8'hff);
            repeat(2)
                begin
                    yapp_012_seq.start(yapp_sequencer);
                end

                foreach(rwregs[i]) begin
                    `uvm_info("RW REG", $sformatf("Reg Number = %d Read_Write Register Name =  %s, regvalue: %d", i+1, rwregs[i].get_name(), rwregs[i]), UVM_NONE)
                end

                foreach(roregs[i]) begin
                    `uvm_info("RO REG", $sformatf("Reg Number = %d Read_Only Register Name =  %s, regvalue: %d", i+1, roregs[i].get_name(), roregs[i]), UVM_NONE)
                end
     phase.drop_objection(this," Finished introspection test");     
    endtask: run_phase

endclass



// //base_test p1;
// class test2 extends base_test;
//     `uvm_component_utils(test2)

//    function new(string name="test2", uvm_component parent);
//         super.new(name, parent);
//     endfunction //new()

// endclass //className extends superClass

// class short_packet_test extends base_test;

//     `uvm_component_utils(short_packet_test)
    
//     function new(string name="short_packet_test", uvm_component parent);
//         super.new(name, parent);
//     endfunction 


//     function void build_phase(uvm_phase phase);
//         set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
//         super.build_phase(phase);
//     endfunction

// endclass

// class set_config_test extends base_test;

//     `uvm_component_utils(set_config_test)

//     function new(string name="set_config_test", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         uvm_config_int::set(this,"inst_tb.environment.agent", "is_active", UVM_PASSIVE);
//     endfunction

// endclass

// class incr_paylaod_test extends base_test;

//     `uvm_component_utils(incr_paylaod_test)

//     function new(string name="incr_paylaod_test", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
       
//         uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                        "default_sequence",
//                        yapp_incr_payload_seq::get_type());
//     endfunction

// endclass
 

// class exhaustive_test extends base_test;

//     `uvm_component_utils(exhaustive_test)

//     function new(string name="exhaustive_test", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
//         uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                        "default_sequence",
//                        yapp_exhaustive_seq::get_type());
//     endfunction
// endclass


// class new_test012 extends base_test;

//     `uvm_component_utils(new_test012)

//     function new(string name="new_test012", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
//         uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                        "default_sequence",
//                        yapp_012_packets::get_type());
//     endfunction
// endclass

// class simple_test extends base_test;

//     `uvm_component_utils(simple_test)

//     function new(string name="simple_test", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        
//         uvm_config_wrapper::set(this, "inst_tb.channel_?.rx_agent.sequencer.run_phase",
//         "default_sequence", channel_rx_resp_seq::get_type());
        
//         uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                        "default_sequence",
//                        yapp_012_packets::get_type());
        
//         uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
//                        "default_sequence", clk10_rst5_seq::get_type());

//     endfunction
// endclass


// class test_uvc_integration extends base_test;

// `uvm_component_utils(test_uvc_integration)

//     function new(string name="test_uvc_integration", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
    
//     super.build_phase(phase);
    
//     set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        
//     uvm_config_wrapper::set(this, "inst_tb.channel_?.rx_agent.sequencer.run_phase",
//         "default_sequence", channel_rx_resp_seq::get_type());
        
//     uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//         "default_sequence", yapp_four::get_type());
        
//     uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
//         "default_sequence", clk10_rst5_seq::get_type());

//     uvm_config_wrapper::set(this, "inst_tb.hbus.masters[?].sequencer.run_phase",
//         "default_sequence", hbus_small_packet_seq::get_type());

//     endfunction: build_phas/*

// reg_function_test
// class  reg_function_test extends base_test;
//     	yapp_tx_sequencer yapp_seqncr;
// 	yapp_012_seq yapp_012;
//     	yapp_regs_c yapp_reg;
//     	uvm_status_e status;
//   // component macro
//   `uvm_component_utils(reg_function_test)
  
//   bit [7:0] rdata, count_addr0, count_addr1, count_addr2, count_addr3;

//   // component constructor
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//   endfunction : new

//   virtual function void build_phase(uvm_phase phase);
//       uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
//       yapp_012 = yapp_012_seq::type_id::create("yapp_012");
//       super.build_phase(phase);
//       uvm_config_wrapper::set(this,"inst_tb.clk_and_rst.agent.sequencer.run_phase","default_sequence",clk10_rst5_seq::get_type());
//       uvm_config_wrapper::set(this,"inst_tb.channel_?.*rx_agent.sequencer.run_phase","default_sequence",channel_rx_resp_seq::get_type());
//   endfunction : build_phase
  
//   virtual function void connect_phase(uvm_phase phase);
//   	yapp_reg = inst_tb.yapp_rm.router_yapp_regs;
//   	yapp_seqncr = inst_tb.yapp_uvc.agent.sequencer;
//   endfunction : connect_phase
  
//   // Functional Verification
//   virtual task run_phase (uvm_phase phase);
//      phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     
//      inst_tb.yapp_rm.default_map.set_check_on_read(1);
    
//      yapp_reg.en_reg.write(status, 1'b1);
//      yapp_reg.en_reg.read(status, rdata);
//      Front_Door_Write_in_RW_reg: assert (rdata ==  8'h01)
//      `uvm_info(get_type_name(),"Router Enabled",UVM_NONE)
//      else
//      `uvm_info(get_type_name(),"Router Not Enabled",UVM_NONE);
       
//      // Set the model property of the sequence to our Register Model instance
//      // Update the RHS of this assignment to match your instance names. Syntax is:
//      //  <testbench instance>.<register model instance>
//      // yapp_reg.model = inst_tb.yapp_rm;
//      // Execute the sequence (sequencer is already set in the testbench)
  
//      yapp_012.start(yapp_seqncr);
     
    
//      yapp_reg.addr0_cnt_reg.read(status, count_addr0);
//      yapp_reg.addr1_cnt_reg.read(status, count_addr1);
//      yapp_reg.addr2_cnt_reg.read(status, count_addr2);
//      yapp_reg.addr3_cnt_reg.read(status, count_addr3);
     
//      `uvm_info(get_type_name(),"\n\n*** All the address counts should be zero *** ",UVM_NONE)
//      `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE); 
//      `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);    
//      `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);    
//      `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n\n",count_addr3),UVM_NONE); 
     
//      yapp_reg.en_reg.write(status, 8'hFF);
     
//      repeat(2)
// 	     begin
//      		 yapp_012.start(yapp_seqncr);
// 	     end
    
//      yapp_reg.addr0_cnt_reg.predict(1);
//      yapp_reg.addr0_cnt_reg.read(status, count_addr0);
//      yapp_reg.addr1_cnt_reg.predict(1);
//      yapp_reg.addr1_cnt_reg.read(status, count_addr1);
//      yapp_reg.addr2_cnt_reg.predict(1);
//      yapp_reg.addr2_cnt_reg.read(status, count_addr2);
//      yapp_reg.addr3_cnt_reg.predict(1);
//      yapp_reg.addr3_cnt_reg.read(status, count_addr3);
//      `uvm_info(get_type_name(),"\n\n *** All the address counts should be incremented *** ",UVM_NONE)
//      `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
//      `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);  
//      `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);  
//      `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n",count_addr3),UVM_NONE); 
     
//      phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
          
//   endtask
  
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

// endclass: test_uvc_integration


// class new_mctest extends base_test;

// `uvm_component_utils(new_mctest)

//     function new(string name="new_mctest", uvm_component parent);
//         super.new(name, parent);
//     endfunction 

//     function void build_phase(uvm_phase phase);
    
//     super.build_phase(phase);
//    uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase","default_sequence", null);
//     set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        
//     uvm_config_wrapper::set(this, "inst_tb.channel_?.rx_agent.sequencer.run_phase",
//         "default_sequence", channel_rx_resp_seq::get_type());
        
//     //uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//     //    "default_sequence", yapp_four::get_type());
        
//     uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
//         "default_sequence", clk10_rst5_seq::get_type());

//     //uvm_config_wrapper::set(this, "inst_tb.mcseqr.run_phase",
//     //    "default_sequence", router_simple_mcseq::get_type());
    
//     uvm_config_wrapper::set(this, "inst_tb.mcseqr.run_phase", "default_sequence", router_simple_mcseq::get_type());

//     endfunction: build_phase

// endclass: new_mctest

// class  uvm_reset_test extends base_test;


// // uvm_mem_walk_seq
// //     uvm_reg_hw_reset_seq reset_seq;

//   // component macro
//   `uvm_component_utils(uvm_reset_test)

//   // component constructor
//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//   endfunction : new

//   function void build_phase(uvm_phase phase);
//       uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
//       reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
//       super.build_phase(phase);

//                uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
//                                 "default_sequence", null);

//         uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
//                        "default_sequence", clk10_rst5_seq::get_type());
//   endfunction : build_phase

//   virtual task run_phase (uvm_phase phase);
//      phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
//      // Set the model property of the sequence to our Register Model instance
//      // Update the RHS of this assignment to match your instance names. Syntax is:
//      //  <testbench instance>.<register model instance>
//      reset_seq.model = inst_tb.yapp_rm;
//      // Execute the sequence (sequencer is already set in the testbench)
//      reset_seq.start(null);
//      phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
     
     
//   endtask

// endclass : uvm_reset_test




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
     //  <testbench instance>./*

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
// <register model instance>
//      // yapp_reg.model = inst_tb.yapp_rm;
//      // Execute the sequence (sequencer is already set in the testbench)
  
//      yapp_012.start(yapp_seqncr);
     
    
//      yapp_reg.addr0_cnt_reg.read(status, count_addr0);
//      yapp_reg.addr1_cnt_reg.read(status, count_addr1);
//      yapp_reg.addr2_cnt_reg.read(status, count_addr2);
//      yapp_reg.addr3_cnt_reg.read(status, count_addr3);
     
//      `uvm_info(get_type_name(),"\n\n*** All the address counts should be zero *** ",UVM_NONE)
//      `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE); 
//      `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);    
//      `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);    
//      `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n\n",count_addr3),UVM_NONE); 
     
//      yapp_reg.en_reg.write(status, 8'hFF);
     
//      repeat(2)
// 	     begin
//      		 yapp_012.start(yapp_seqncr);
// 	     end
    
//      yapp_reg.addr0_cnt_reg.predict(1);
//      yapp_reg.addr0_cnt_reg.read(status, count_addr0);
//      yapp_reg.addr1_cnt_reg.predict(1);
//      yapp_reg.addr1_cnt_reg.read(status, count_addr1);
//      yapp_reg.addr2_cnt_reg.predict(1);
//      yapp_reg.addr2_cnt_reg.read(status, count_addr2);
//      yapp_reg.addr3_cnt_reg.predict(1);
//      yapp_reg.addr3_cnt_reg.read(status, count_addr3);
//      `uvm_info(get_type_name(),"\n\n *** All the address counts should be incremented *** ",UVM_NONE)
//      `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
//      `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);  
//      `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);  
//      `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n",count_addr3),UVM_NONE); 
     
//      phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
          
//   endtask
  
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
// */
//      yapp_reg.en_reg.write(status, 8'hFF);
     
//      repeat(2)
// 	     begin
//      		 yapp_012.start(yapp_seqncr);
// 	     end
     
//      `uvm_info(get_type_name(),"\n\n *** All the address counts should be incremented *** ",UVM_NONE)
//      yapp_reg.addr0_cnt_reg.read(status, count_addr0);
//      yapp_reg.addr1_cnt_reg.read(status, count_addr1);
//      yapp_reg.addr2_cnt_reg.read(status, count_addr2);
//      yapp_reg.addr3_cnt_reg.read(status, count_addr3);
//      `uvm_info(get_type_name(),$sformatf("Address_0 register count = %0d",count_addr0),UVM_NONE);
//      `uvm_info(get_type_name(),$sformatf("Address_1 register count = %0d",count_addr1),UVM_NONE);  
//      `uvm_info(get_type_name(),$sformatf("Address_2 register count = %0d",count_addr2),UVM_NONE);  
//      `uvm_info(get_type_name(),$sformatf("Address_3 register count = %0d\n",count_addr3),UVM_NONE); 
     
//      phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
          
//   endtask
// endclass : reg_function_test
// */