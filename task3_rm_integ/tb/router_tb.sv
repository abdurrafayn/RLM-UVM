class router_tb extends uvm_env;
    

    // adding local handles for the register model and HBUS adapter (from the HBUS UVC)
    yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5 yapp_rm;
    hbus_reg_adapter reg2bus;


`uvm_component_utils_begin(router_tb)
    `uvm_field_object(yapp_rm, UVM_ALL_ON)
    `uvm_field_object(reg2bus, UVM_ALL_ON)
`uvm_component_utils_end


    function new(string name ="router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    // multiple UVCs (handles of UVCs)
    yapp_env environment;
    channel_env channel_0;
    channel_env channel_1;
    channel_env channel_2;
    hbus_env hbus;
    clock_and_reset_env clock_and_reset;
    router_mcsequencer mcseqr;

    function void build_phase(uvm_phase phase);
    
        // environment = new("environment", this);
        super.build_phase(phase);
        `uvm_info("build_phase","Build base of base test is executing", UVM_HIGH);


        // creating the register model instance

        yapp_rm = yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5::type_id::create("yapp_rm", this);
        yapp_rm.build();
        yapp_rm.lock_model();

        yapp_rm.default_map.set_auto_predict(1);
        yapp_rm.set_hdl_path_root("hw_top.dut");

        reg2bus = hbus_reg_adapter::type_id::create("reg2hbus", this);


        environment = yapp_env::type_id::create("environment", this);
        // using configuration set method to set the channel id

        uvm_config_int::set(this, "channel_0", "channel_id", 0);
        uvm_config_int::set(this, "channel_1", "channel_id", 1);
        uvm_config_int::set(this, "channel_2", "channel_id", 2);
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);

        uvm_config_int::set(this, "clock_and_reset", "channel_id", 2);

        channel_0 = channel_env::type_id::create("channel_0", this);
        channel_1 = channel_env::type_id::create("channel_1", this);
        channel_2 = channel_env::type_id::create("channel_2", this);
        hbus = hbus_env::type_id::create("hbus", this);
        clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
        mcseqr= router_mcsequencer::type_id::create("mcseqr", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
    mcseqr.hbus = hbus.masters[0].sequencer;
    mcseqr.yapp = environment.agent.sequencer;      

    yapp_rm.default_map.set_sequencer(hbus.masters[0].sequencer, reg2bus);



    endfunction

endclass: router_tb