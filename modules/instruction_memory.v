// память инструкций - это огромный мультиплексор, ко входам которого подцеплены константы
// в out непрерывно выдаётся значение ячейки по смещению sel
// если смещение sel не кратно четырём, то всегда выдаётся ноль
// каждая ячейка - 32 бита, в которых записана инструкция в формате MIPS
// куча параметров - это куски инструкции, чтобы можно было делать ячейки памяти более читаемыми
`timescale 1ns/1ns
module instruction_memory
  ( input [31:0] sel,
    output reg [31:0] out
  );
  
  parameter OP_R = 6'b000000;
  parameter OP_ADDI = 6'b001000;
  parameter OP_BEQ = 6'b000100;
  parameter OP_BNE = 6'b000101;
  parameter OP_LW = 6'b100011;
  parameter OP_SW = 6'b101011;
  parameter OP_ADDIU = 6'b001001;
  parameter OP_ANDI = 6'b100101;
  parameter OP_ANDIU = 6'b100100;
  parameter OP_ORI = 6'b100111;
  parameter OP_ORIU = 6'b100110;
  parameter OP_SLTI = 6'b100011;
  parameter OP_SLTIU = 6'b100010;
  parameter OP_J = 6'b000001;
  
  parameter OPR_ADD = 6'b100000;
  parameter OPR_SUB = 6'b100010;
  parameter OPR_AND = 6'b100100;
  parameter OPR_OR = 6'b100101;
  parameter OPR_SLTU = 6'b101011;
  parameter OPR_SLT = 6'b101010;

  parameter OPR_ADDU = 6'b100001;
  parameter OPR_SUBU = 6'b100011;
  
  parameter R00 = 5'd0;
  parameter R01 = 5'd1;
  parameter R02 = 5'd2;
  parameter R03 = 5'd3;
  parameter R04 = 5'd4;
  parameter R05 = 5'd5;
  parameter R06 = 5'd6;
  parameter R07 = 5'd7;
  parameter R08 = 5'd8;
  parameter R09 = 5'd9;
  parameter R10 = 5'd10;
  parameter R11 = 5'd11;
  parameter R12 = 5'd12;
  parameter R13 = 5'd13;
  parameter R14 = 5'd14;
  parameter R15 = 5'd15;
  parameter R16 = 5'd16;
  parameter R17 = 5'd17;
  parameter R18 = 5'd18;
  parameter R19 = 5'd19;
  parameter R20 = 5'd20;
  parameter R21 = 5'd21;
  parameter R22 = 5'd22;
  parameter R23 = 5'd23;
  parameter R24 = 5'd24;
  parameter R25 = 5'd25;
  parameter R26 = 5'd26;
  parameter R27 = 5'd27;
  parameter R28 = 5'd28;
  parameter R29 = 5'd29;
  parameter R30 = 5'd30;
  parameter R31 = 5'd31;
  
  parameter ZERO_SHAMT = 5'b00000;
  
  always @(sel)
  case(sel)
    32'd0 : out = {OP_ADDI, R00, R00, 16'd3}; // $0 = $0 + 3 -> $0 == 3
    32'd4 : out = {OP_ADDIU, R01, R01, 16'd4}; // $1 = $1 + 4 -> $1 == 4
    32'd8 : out = {OP_SW, R00, R01, 16'd0}; // MEM[$0 + 0] = $1 -> MEM[3] == 4
    32'd12 : out = {OP_R, R00, R01, R02, ZERO_SHAMT, OPR_ADDU}; // $2 = $1 + $0 -> $2 == 7
    32'd16 : out = {OP_R, R00, R01, R03, ZERO_SHAMT, OPR_ADDU}; // $3 = $1 + $0 -> $3 == 7
    32'd20 : out = {OP_LW, R00, R03, 16'd0}; // $3 = MEM[$0 + 0] -> $3 == 4
    32'd24 : out = {OP_BEQ, R02, R03, -16'd3}; // if($2 == $3) jump to (24 + 4 + 4 * (-3)) = 16
    32'd28 : out = {OP_ADDI, R04, R04, 16'd0}; // $4 = $4 + 0 -> $4 == 0
    32'd32 : out = {OP_ADDI, R00, R00, -16'd1}; // $0 = $0 + (-1) -> $0-- 
    32'd36 : out = {OP_BNE, R00, R04, -16'd2}; // if($0 != $4) jump to (36 + 4 + 4 * (-2)) = 32
    32'd40 : out = {OP_J, 26'd0}; // jump to 4 * 0 = 0
    default: out = 0;
  endcase
endmodule
