
module select_carry_adder_test_bench ();

reg Cin;
reg [15:0] A ;
reg [15:0] B ;
wire [15:0] S ;
wire Cout;

sixteen_bits_select_adder a1 (Cin,A,B,S,Cout);

initial begin
$monitor ("The sum of A=%b + B=%b + Cin=%b is S=%b + Cout=%b",A,B,Cin,S,Cout);
#0 A= {4{4'b1001}};  B= {4{4'b1001}};  Cin = 0 ;
 
#50  A= {4{4'b011}};  B= {4{4'b0011}};  Cin = 0 ;

#100  A= {4{4'b1111}};  B= {4{4'b1111}};  Cin = 0 ;

#150  A= {4{4'b0000}};  B= {4{4'b0000}};  Cin = 0 ;

#200  A= {4{4'b1001}};  B= {4{4'b1001}};  Cin = 1 ;
 
#250  A= {4{4'b011}};  B= {4{4'b0011}};  Cin = 1 ;

#300  A= {4{4'b1111}};  B= {4{4'b1111}};  Cin = 1 ;

#350  A= {4{4'b0000}};  B= {4{4'b0000}};  Cin = 1 ;
end



endmodule

module sixteen_bits_select_adder (Cin,A,B,S,Cout); 

input Cin;

input [15:0] A;

input [15:0] B;

output [15:0] S;

output Cout ;

wire [3:0] S0 ;
wire [3:0] S1 ;
wire [3:0] S2 ;
wire [3:0] S3 ;


wire C1;  // The carry of the first sum.
wire C2;  // The carry of the second sum.
wire C3;  // The carry of the third sum.

//The first sum

four_bits_ripple_carry_adder f0(Cin,A[3:0],B[3:0],S0,C1); // The first sum doesn't need a mux


//The second sum


wire [3:0] S1temp0 ;
wire [3:0] S1temp1 ;

wire C1temp0;
wire C1temp1;

 
four_bits_ripple_carry_adder f10(0,A[7:4],B[7:4],S1temp0,C1temp0);
four_bits_ripple_carry_adder f11(1,A[7:4],B[7:4],S1temp1,C1temp1);

assign S1 = (C1==0) ? S1temp0 : S1temp1 ;
assign C2 = (C1==0) ? C1temp0 : C1temp1 ;



//



//The third sum


wire [3:0] S2temp0 ;
wire [3:0] S2temp1 ;

wire C2temp0;
wire C2temp1;

 
four_bits_ripple_carry_adder f20(0,A[11:8],B[11:8],S2temp0,C2temp0);
four_bits_ripple_carry_adder f21(1,A[11:8],B[11:8],S2temp1,C2temp1);

assign S2 = (C2==0) ? S2temp0 : S2temp1 ;
assign C3 = (C2==0) ? C2temp0 : C2temp1 ;



//


//The fourth (final) sum


wire [3:0] S3temp0 ;
wire [3:0] S3temp1 ;

wire C3temp0;
wire C3temp1;

 
four_bits_ripple_carry_adder f30(0,A[15:12],B[15:12],S3temp0,C3temp0);
four_bits_ripple_carry_adder f31(1,A[15:12],B[15:12],S3temp1,C3temp1);

assign S3 = (C3==0) ? S3temp0 : S3temp1 ;
assign Cout = (C3==0) ? C3temp0 : C3temp1 ;



//




assign S= {S3,S2,S1,S0};







endmodule

module four_bits_ripple_carry_adder(Cin, A, B,S,C);
   output [3:0] S;  // The 4-bit sum.
   output 	C;  // The 1-bit carry.
   input [3:0] 	A;  // The 4-bit augend.
   input [3:0] 	B;  // The 4-bit addend.
   input Cin ; //The input carry.



   wire 	C0; // The carry out bit of fa0, the carry in bit of fa1.
   wire 	C1; // The carry out bit of fa1, the carry in bit of fa2.
   wire 	C2; // The carry out bit of fa2, the carry in bit of fa3.
	
   full_adder fa0(S[0], C0, A[0], B[0], Cin);    // Least significant bit.
   full_adder fa1(S[1], C1, A[1], B[1], C0);
   full_adder fa2(S[2], C2, A[2], B[2], C1);
   full_adder fa3(S[3], C, A[3], B[3], C2);    // Most significant bit.
endmodule // ripple_carry_adder

module full_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;
   
   wire   w1;
   wire   w2;
   wire   w3;
   wire   w4;
   
   xor(w1, A, B);
   xor(S, Cin, w1);
   and(w2, A, B);   
   and(w3, A, Cin);
   and(w4, B, Cin);   
   or(Cout, w2, w3, w4);
endmodule // full_adder

/*
module two_to_one_mux (in1,in2,select,out);
input in1,in2,select;
output out;
wire [3:0] in1;

wire [3:0] in2;

wire select;

wire [3:0] out;

//assign out= (select==0) ? in1 : in2 ;

always @ (in1 or in2 or select)
if (select==0)
out=in1;
else
out=in2;

endmodule //Mux
*/
