module game_logc ( input b0, b1, activate, clck);

initial
begin
reg count = 3'b000; // count serial input
reg turn = 1'b0; // 0 means triangle's turn, 1 means circle's turn
reg valid = 1'b0; // validity of entered coordinates
end


reg [3:0] x_buff;
reg [3:0] y_buff;
reg [1:0} pos_check[9:0][9:0]}; //info of a position in 2d array , 0x empty, 10 triangle, 11 circle

//serial input into buffer variables
always @(posedge b0 || b1)
	begin
	if(count<4)  //take first 4 inputs in Y
		if(b0)
		y_buff <= {b0,y_buff[3:1]};
		else
		y_buff <= {b1,y_buff[3:1]};
	else			//after 4 inputs take them in X
		if(b0)
		x_buff <= {b0,x_buff[3:1]};
		else
		x_buff <= {b1,x_buff[3:1]};
	
	count = count+1;
	if(count == 8)		//when count reaches 8 reset counter
		count = 3'b000;
	end

	//take coordinates into actual variables upon pressing activity button
if(activate)
begin
	if(x_buff<10 && y_buff<10)
		valid = 1;
	else
		valid = 0;
		
	if(valid && ~pos_check[y_buff][x_buff][1]) //check if valid coords and empty position
	begin
		pos_check[y_buff][x_buff] = {1,turn};
		turn = turn+1;
	else
	// enter new coords 
	end
end

