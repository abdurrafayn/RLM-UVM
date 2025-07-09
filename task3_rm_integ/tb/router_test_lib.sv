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



class reg_access_test extends base_test;

    int rdata;


    yapp_regs_c yapp_regs;
    uvm_status_e status;

    // component macro
  `uvm_component_utils(reg_access_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
     // reset_seq = reg_access_test::type_id::create("uvm_reset_seq");
      super.build_phase(phase);

        uvm_config_wrapper::set(this, "inst_tb.environment.agent.sequencer.run_phase",
                                "default_sequence", null);

        uvm_config_wrapper::set(this, "inst_tb.clock_and_reset.agent.sequencer.run_phase",
                       "default_sequence", clk10_rst5_seq::get_type());
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
    phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
        yapp_regs.en_reg.write(status, 8'hA5); // Front-door write a unique value
        yapp_regs.en_reg.peek(status, rdata); // Peek and check the DUT value matches the written value.
        `uvm_info("get_type_name()", $sformatf("Read value from en_reg: %0h", rdata), UVM_LOW);
        //assert(rdata == 8'hA5) else `uvm_info(get_type_name(), $sformatf("RW TEST: Data Read is %h", rdata), UVM_LOW);

        yapp_regs.en_reg.poke(status, 8'h5A); // poke a new value to the register
        yapp_regs.en_reg.read(status, rdata); // Front-door read the new value and check it matches.
        `uvm_info("get_type_name()", $sformatf("Read value from en_reg: %0h", rdata), UVM_LOW);
        //assert(rdata == 8'h5A) else `uvm_info(get_type_name(), $sformatf("RW TEST: Data Read is %h", rdata), UVM_LOW);
        


        // RO
        yapp_regs.addr0_cnt_reg.poke(status, 8'hA5); //Poke a unique value.
        yapp_regs.addr0_cnt_reg.read(status, rdata); // Front-door read and check the value matches
        `uvm_info("get_type_name()", $sformatf("Read value from en_reg: %0h", rdata), UVM_LOW);

        yapp_regs.addr0_cnt_reg.write(status, 8'h5A); //Front-door write a new value
        yapp_regs.addr0_cnt_reg.peek(status, rdata); //Peek and check the DUT value has not changed
        `uvm_info("get_type_name()", $sformatf("Read value from en_reg: %0h", rdata), UVM_LOW);

     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");     
  endtask

  function void connect_phase(uvm_phase phase);

    yapp_regs = inst_tb.yapp_rm.router_yapp_regs;

    endfunction: connect_phase

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

//     endfunction: build_phase

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




