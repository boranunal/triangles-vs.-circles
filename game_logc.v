module game_logc ( b0, b1, activity, clck, triangle_win, circle_win, test,test0,test1,test2,test3,h_slider,h_empty,v_slider,v_empty,dpos_slider,dpos_empty,dneg_slider,dneg_empty);

input b0, b1, activity, clck;

output triangle_win, circle_win;
output reg [3:0] test,test0,test1,test2,test3;


reg [3:0] count;
reg turn;		// 0 means triangle's turn, 1 means circle's turn
reg game_tick; //write code for this
reg [1:0] pos_check[0:9][0:9]; //info of a position in 2d array , 0x empty, 10 triangle, 11 circle
reg reset;	//write code for this, reset poscheck
integer i, j;

initial
begin
count = 3'b000; // count serial input
turn = 1'b0; 
reset = 1'b0;
test = 0;
for(i=0;i<10;i=i+1)
	for(j=0;j<10;j=j+1)
	pos_check[i][j] = 2'b00;
end



reg [3:0] x_buff;
reg [3:0] y_buff;

//serial input into buffer variables
wire y;
assign y = (b0|b1);
always @(posedge y)
	
	begin
	if(count<4)  //take first 4 inputs in Y
		if(b0)
		y_buff = {1'b0,y_buff[3:1]};
		else
		y_buff = {1'b1,y_buff[3:1]};
	if(4<=count)			//after 4 inputs take them in X
		if(b0)
		x_buff = {1'b0,x_buff[3:1]};
		else
		x_buff = {1'b1,x_buff[3:1]};
	$display("%d",count);
	count = count+1'b1;
	test0 = y_buff;
	test1 = x_buff;

	if(count == 8)		//when count reaches 8 reset counter
		count = 3'b000;
	end //zaten 0 oluyor 8 olmuyor

	//take coordinates into a 2d array upon pressing activity button

always @(posedge activity)
begin
	

	if(~pos_check[y_buff][x_buff][1]) //check if valid coords and empty position
	begin
		pos_check[y_buff][x_buff] = {1'b1,turn};
		test = pos_check[y_buff][x_buff];
		turn = ~turn;
	//else
	// enter new coords 
	end
end

output reg [3:0] h_slider,h_empty;  //'empty' variables are msb of poscheck array, 0 if empty
output reg [3:0] v_slider,v_empty;
output reg [3:0] dpos_slider,dpos_empty;
output reg [3:0] dneg_slider,dneg_empty;


assign triangle_win = ((&h_empty)&(~|h_slider))|((&v_empty)&(~|v_slider))|((&dpos_empty)&(~|dpos_slider))|((&dneg_empty)&(~|dneg_slider));
assign circle_win = ((&h_empty)&(&h_slider))|((&v_empty)&(&v_slider))|((&dpos_empty)&(&dpos_slider))|((&dneg_empty)&(&dneg_slider));

always @(activity)
begin

for(i=0;i<7;i=i+1)
	for(j=0;j<7;j=j+1) begin
	
	h_slider={pos_check[i][j][0],pos_check[i][j+1][0],pos_check[i][j+2][0],pos_check[i][j+3][0]};
	h_empty={pos_check[i][j][1],pos_check[i][j+1][1],pos_check[i][j+2][1],pos_check[i][j+3][1]};
	
	v_slider={pos_check[i][j][0],pos_check[i+1][j][0],pos_check[i+2][j][0],pos_check[i+3][j][0]};
	v_empty={pos_check[i][j][1],pos_check[i+1][j][1],pos_check[i+2][j][1],pos_check[i+3][j][1]};
	
	dpos_slider={pos_check[i][j][0],pos_check[i+1][j+1][0],pos_check[i+2][j+2][0],pos_check[i+3][j+3][0]};
	dpos_empty={pos_check[i][j][1],pos_check[i+1][j+1][1],pos_check[i+2][j+2][1],pos_check[i+3][j+3][1]};
	
	dneg_slider={pos_check[i+3][j][0],pos_check[i+2][j+1][0],pos_check[i+1][j+2][0],pos_check[i][j+3][0]};
	dneg_empty={pos_check[i+3][j][1],pos_check[i+2][j+1][1],pos_check[i+1][j+2][1],pos_check[i][j+3][1]};
	end

end
endmodule

