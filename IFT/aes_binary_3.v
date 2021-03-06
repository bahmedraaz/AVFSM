module aes_binary (state_present, state_next, extra_FF, n10004, clk, data_stable, key_ready, finished, round_type_sel ); 
    output [1:0] round_type_sel;  
  
 input [2:0] state_present; 
input [2:0] state_next; 
input [3:0] extra_FF; 
output n10004; 
 
 wire   n10000, n10001, n10002, n10003, n10004; 
    input clk, data_stable, key_ready;  
    output finished;  
    wire   finished, N13, N14, N15, N16, N17, N18, N19, N20, N21, N22, N23, N24,  
           N25, N26, N27, N28, N30, N31, N32, N33, N34, N44, N45, N46, N47, N48,  
           N49, N50, N51, N52, N53, N54, N56, N57, N58, N59, n8, n9, n10, n11,  
           n12, n13, n14, n15, n16, n17, n18;  
    wire   [2:0] FSM;  
    wire   [2:0] next_FSM;  
    wire   [3:0] round_index;  
    wire   [3:0] next_round_index;  
    wire   [3:2] add_156_carry;  
    assign round_type_sel[1] = finished;  
    
 assign FSM[2] = state_present[2];  
  assign FSM[1] = state_present[1];  
  assign FSM[0] = state_present[0];  
  assign round_index[1] = extra_FF[0];  
  assign round_index[2] = extra_FF[1];  
  assign round_index[3] = extra_FF[2];  
  assign round_index[0] = extra_FF[3];  
   
 OR2X1 U10003 ( .A(n10000), .B(n10001), .Y(n10003) );  
  OR2X1 U10004 ( .A(n10002), .B(n10003), .Y(n10004) );  
   
    ADDHX1 add_156_U1_1_1 ( .A(round_index[1]), .B(round_index[0]), .CO(  
          add_156_carry[2]), .S(N56) );  
    ADDHX1 add_156_U1_1_2 ( .A(round_index[2]), .B(add_156_carry[2]), .CO(  
          add_156_carry[3]), .S(N57) );  
    XOR2X1 add_156_U2 ( .A(round_index[3]), .B(add_156_carry[3]), .Y(N58) );  
    CLKBUFX1 B_14 ( .A(N51), .Y(finished) );  
    CLKBUFX1 B_13 ( .A(N49), .Y(round_type_sel[0]) );  
    OR2X1 C174 ( .A(N52), .B(N53), .Y(N54) );  
    INVX1 I_13 ( .A(N48), .Y(N49) );  
    INVX1 I_12 ( .A(N45), .Y(N46) );  
    INVX1 I_9 ( .A(N26), .Y(N27) );  
    INVX1 I_8 ( .A(FSM[2]), .Y(N24) );  
    INVX1 I_7 ( .A(N22), .Y(N23) );  
    INVX1 I_6 ( .A(N19), .Y(N20) );  
    INVX1 I_5 ( .A(FSM[1]), .Y(N17) );  
    INVX1 I_4 ( .A(N15), .Y(N16) );  
    INVX1 I_3 ( .A(FSM[0]), .Y(N13) );  
    AND2X1 C94 ( .A(N24), .B(N17), .Y(N50) );  
    OR2X1 C88 ( .A(N24), .B(FSM[1]), .Y(N47) );  
    OR2X1 C84 ( .A(FSM[2]), .B(N17), .Y(N44) );  
    OR2X1 C54 ( .A(N31), .B(N33), .Y(N34) );  
    OR2X1 C53 ( .A(round_index[1]), .B(N32), .Y(N33) );  
    OR2X1 C52 ( .A(round_index[2]), .B(N30), .Y(N32) );  
    INVX1 I_1 ( .A(round_index[0]), .Y(N31) );  
    INVX1 I_0 ( .A(round_index[3]), .Y(N30) );  
    AND2X1 C24 ( .A(N24), .B(N17), .Y(N28) );  
    OR2X1 C18 ( .A(N24), .B(FSM[1]), .Y(N25) );  
    OR2X1 C14 ( .A(FSM[2]), .B(N17), .Y(N21) );  
    OR2X1 C9 ( .A(FSM[2]), .B(N17), .Y(N18) );  
    OR2X1 C5 ( .A(FSM[2]), .B(FSM[1]), .Y(N14) );  
  XOR2X1 U10000 ( .A(next_FSM[2]), .B(state_next[2]), .Y(n10000) );  
  XOR2X1 U10001 ( .A(next_FSM[1]), .B(state_next[1]), .Y(n10001) );  
  XOR2X1 U10002 ( .A(next_FSM[0]), .B(state_next[0]), .Y(n10002) );  
    AND2X1 U10 ( .A(round_type_sel[0]), .B(N58), .Y(next_round_index[3]) );  
    AND2X1 U11 ( .A(N57), .B(round_type_sel[0]), .Y(next_round_index[2]) );  
    AND2X1 U12 ( .A(N56), .B(round_type_sel[0]), .Y(next_round_index[1]) );  
    INVX1 U13 ( .A(n8), .Y(next_round_index[0]) );  
    AOI21X1 U14 ( .A0(round_type_sel[0]), .A1(N31), .B0(N46), .Y(n8) );  
    NOR2X1 U15 ( .A(n9), .B(n10), .Y(next_FSM[2]) );  
    AOI21X1 U16 ( .A0(N34), .A1(N27), .B0(N23), .Y(n9) );  
    AOI21X1 U17 ( .A0(n11), .A1(n12), .B0(n10), .Y(next_FSM[1]) );  
    INVX1 U18 ( .A(key_ready), .Y(n10) );  
    NAND2X1 U19 ( .A(N28), .B(N13), .Y(n12) );  
    NOR2X1 U20 ( .A(N20), .B(N16), .Y(n11) );  
    NAND2X1 U21 ( .A(key_ready), .B(n13), .Y(next_FSM[0]) );  
    NAND2X1 U22 ( .A(data_stable), .B(N20), .Y(n13) );  
    INVX1 U23 ( .A(N54), .Y(N59) );  
    NOR2X1 U24 ( .A(N24), .B(N17), .Y(N53) );  
    NOR2X1 U25 ( .A(N24), .B(N13), .Y(N52) );  
    AND2X1 U26 ( .A(N50), .B(N13), .Y(N51) );  
    OR2X1 U27 ( .A(N47), .B(n14), .Y(N48) );  
    OR2X1 U28 ( .A(N13), .B(N44), .Y(N45) );  
    OR2X1 U29 ( .A(N25), .B(n14), .Y(N26) );  
    OR2X1 U30 ( .A(N13), .B(N21), .Y(N22) );  
    OR2X1 U31 ( .A(N18), .B(n14), .Y(N19) );  
    INVX1 U32 ( .A(N13), .Y(n14) );  
    OR2X1 U33 ( .A(N13), .B(N14), .Y(N15) );  
    MX2X1 U34 ( .A(round_index[0]), .B(next_round_index[0]), .S0(N59), .Y(n18)  
           );  
    MX2X1 U35 ( .A(round_index[3]), .B(next_round_index[3]), .S0(N59), .Y(n17)  
           );  
    MX2X1 U36 ( .A(round_index[2]), .B(next_round_index[2]), .S0(N59), .Y(n16)  
           );  
    MX2X1 U37 ( .A(round_index[1]), .B(next_round_index[1]), .S0(N59), .Y(n15)  
           );  
  endmodule    
   
 