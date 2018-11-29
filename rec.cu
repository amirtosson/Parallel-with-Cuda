#include <iostream>
#include <fstream>
#include <string>
#include <stdio.h>
#include <math.h>
#include <vector> 
#include <time.h> 

using namespace std; 




__global__ void tryy(float *d_engrec,float *d_xrec,float *d_yrec, float *d_xx, float *d_yy, float *d_engg, float *d_inx, int blocks){

int is,il;
int count2;
int globalIndex= (blockIdx.x * blocks) + threadIdx.x;
 is= d_inx[globalIndex];
 il= d_inx[globalIndex+1];
 count2=is;
for(int j=is;j<il;j++){
    if((d_yy[j]<(d_yy[j+1]-1))||(d_yy[j]==d_yy[j+1]&& d_xx[j]<(d_xx[j+1]-2))){
                        d_xrec[count2]=d_xx[j];
                          d_yrec[count2]=d_yy[j];
                          d_engrec[count2]=d_engg[j];
                          count2++;
                        }
                        
 //================================================double                       
else if  (((d_yy[j]== d_yy[j+1]) && (d_xx[j+1]== (d_xx[j]+1)) && ((d_xx[j+2]>d_xx[j+1]+1)))  || ((((d_yy[j+2]>d_yy[j+1]+1)) && ( ((d_yy[j+1]+1== d_yy[j+1])   &&   (d_xx[j]== (d_xx[j+1]))) ))))
{           d_engrec[count2]= d_engg[j]+ d_engg[j+1];
                if(d_xx[j]== d_xx[j+1] ){
                    if(d_engg[j]> d_engg[j+1]){
                        d_xrec[count2]=d_xx[j];
                        d_yrec[count2]=d_yy[j];
                    }
                   else{
                    d_xrec[count2]=d_xx[j+1];
                    d_yrec[count2]=d_yy[j+1];
                       }}
                if(d_yy[j]== d_yy[j+1]){
                   if(d_engg[j]> d_engg[j+1]){
                        d_yrec[count2]=d_yy[j];
                        d_xrec[count2]=d_xx[j];
                                             }
                    else{
                    d_yrec[count2]=d_yy[j+1];
                    d_xrec[count2]=d_xx[j+1];
                       }}
                         j++;
                        count2++;
                         }   
                         
                         
///========================================triple event recombination
else if ((d_yy[j]==d_yy[j+2]&& d_yy[j+3]>(d_yy[j+2]+1))||( d_yy[j]==(d_yy[j+2]+1)&& d_xx[j]<(d_xx[j+3]+1)))
         
         {
            d_engrec[count2]= d_engg[j]+ d_engg[j+1]+ d_engg[j+2];
             d_yrec[count2]=d_yy[j+2];
             d_xrec[count2]=d_xx[j+2];
              j++;
              j++;
            count2++;
         }

 ///==========================================quad event recombination




 else if(d_yy[j]== d_yy[j+1] && d_yy[j+2]== d_yy[j+3]/*&& y[o]<(y[o+4]-1)*/&&d_xx[j]==(d_xx[j+1]+1) ) {
            d_engrec[count2]= d_engg[j]+ d_engg[j+1]+ d_engg[j+2]+ d_engg[j+3];
            
             d_yrec[count2]=d_yy[j+2];
             d_xrec[count2]=d_xx[j+2];
             
//             if ((eng.at(o)>eng.at(o+1))&&(eng.at(o)>eng.at(o+2))&&(eng.at(o)>eng.at(o+3))){
//             x_rec.push_back(x.at(o));
//             y_rec.push_back(y.at(o));
//             }
//              if ((eng.at(o+1)>eng.at(o))&&(eng.at(o+1)>eng.at(o+2))&&(eng.at(o+1)>eng.at(o+3))){
//             x_rec.push_back(x.at(o+1));
//             y_rec.push_back(y.at(o+1));
//             }
//              if ((eng.at(o+2)>eng.at(o+1))&&(eng.at(o+2)>eng.at(o))&&(eng.at(o+2)>eng.at(o+3))){
//             x_rec.push_back(x.at(o+2));
//             y_rec.push_back(y.at(o+2));
//             }
//              if ((eng.at(o+3)>eng.at(o+1))&&(eng.at(o+3)>eng.at(o+2))&&(eng.at(o+3)>eng.at(o))){
//             x_rec.push_back(x.at(o+3));
//             y_rec.push_back(y.at(o+3));
//             }
             //cout << "quad"<< endl;
              //cout << x_rec.at(o)<< y_rec.at(o)<<endl;
              j++;
              j++;
              j++;
            count2++;
         }                        
                        
    
}}
    
    




int main(){


ifstream file( "c12_siegen_19072017_01", ios::in );
    string part1,part2;
    string dd= "HT";
    string dd2= "SF";
    int num1, num2, num3;
    int numb=0 ;
    int subnumb=0 ;
    int nframe=0;
    
 
   int cou=0;
    if( !file )
        cerr << "Cant open " << endl;
    while( file >> part1 )
    {
        if (part1 == dd){
        numb++;
        }
        
       if (part1 == dd2){
       nframe++;
       }
    }
       
 //===========================================================================================================================   
    float frameIndexr[nframe+1];//x[numb], y[numb] , eng[numb], 
    float *x= new float[numb]; 
    float *y= new float[numb];
    float *eng= new float[numb];
    
    frameIndexr[0]=0;
    int cou2=1;
int rf=1000;

    //cout<<"i am here  "<< numb<<endl;
  ifstream file2( "c12_siegen_19072017_01", ios::in );
   while( file2 >> part2 >>  num1 >> num2>> num3 )
    {  if (cou2>rf)break;
        if (part2 == dd){
        x[cou]= num1;
        y[cou]=num2;
        eng[cou]=num3;
       // cout<<eng[cou]<<endl;
        cou++;
	subnumb++;
   
        }
        
       if (part2 == dd2){
        frameIndexr[cou2]=frameIndexr[cou2-1]+subnumb;
        //cout<<frameIndexr[cou2]<<endl;
        subnumb=0;
        cou2++;
       }
    }    
   
    
 //===================================================================================   
    
    
    
    
    
int sizeFrame=nframe+1; 
//cout<<"  "<<sizeFrame<<"  "<< nframe<<endl;

//int x[numb],y[numb],eng[numb],frameIndex[sizeFrame];

// for (int i=0 ; i<numb ; i++){
// x[i]=xr[i];
// y[i]=yr[i];
// eng[i]=engr[i];
// }

// int count=0;
// for (int i2=1 ; i2<sizeFrame ; i2++){
// count=count+frameIndexr[i2-1];
// frameIndexr[i2]=count;
// //cout<<frameIndex[i2]<<endl;
// }

 
const int data_bytes= numb* sizeof(float); //the required memory 
const int data_bytes_2= sizeFrame * sizeof(float); 

///===========================Declaration===============================
// int h_engres[numb]; // CPU array for results
// int h_xres[numb];
// int h_yres[numb];
//cout<<"i am here  "<<endl; 

//=====================declaration of GPU
float *d_yin;
float *d_xin;
float *d_engin;
float *d_engres;
float *d_xres;
float *d_yres;
float *d_ind;
///=================== allocate GPU mem===============
cudaMalloc((void **) &d_engin, data_bytes);
cudaMalloc((void **) &d_engres, data_bytes);
cudaMalloc((void **) &d_xres, data_bytes);
cudaMalloc((void **) &d_yres, data_bytes);
cudaMalloc((void **) &d_xin, data_bytes);
cudaMalloc((void **) &d_yin, data_bytes);
cudaMalloc((void **) &d_ind, data_bytes_2);

///================== define number of blocks with constant 1024 threads per block===========
int nthreadsperblock=32; //number of threads per block
int nblock; //number of blocks
if(sizeFrame%nthreadsperblock == 0){
nblock=sizeFrame/nthreadsperblock;
}  
else{nblock=(sizeFrame/nthreadsperblock)+1;}
//cout<< nblock << "  "<< nthreadsperblock<<endl;

///===================== copy the data to the GPU=============
cudaMemcpy(d_xin, x, data_bytes, cudaMemcpyHostToDevice);
cudaMemcpy(d_yin, y, data_bytes, cudaMemcpyHostToDevice);
cudaMemcpy(d_engin, eng, data_bytes, cudaMemcpyHostToDevice);
cudaMemcpy(d_ind,frameIndexr, data_bytes_2, cudaMemcpyHostToDevice);
clock_t   tG0=clock();
tryy<<<nblock,nthreadsperblock>>>(d_engres,d_xres,d_yres,d_xin,d_yin,d_engin,d_ind,nthreadsperblock);  

cudaMemcpy(eng,d_engres, data_bytes, cudaMemcpyDeviceToHost);
cudaMemcpy(x,d_xres, data_bytes, cudaMemcpyDeviceToHost);
cudaMemcpy(y,d_yres, data_bytes, cudaMemcpyDeviceToHost);
clock_t   tGf=clock();
int single=0;
for (int i2=0 ; i2<numb ; i2++){
    if(eng[i2]>0){
//cout<<eng[i2]<<"  "<<x[i2]<<"  "<<y[i2]<<endl;
        single++;
    }}

///=====================================================CPU=================================================================================================
//==========================================================================================================================================================
int frame[384][384]={{}};
   int bg[384][384]={{}};
   vector<int> xc;
   vector<int> yc;
   vector<int> engc;
vector<int> x_rec;
    vector<int> y_rec;
    vector<int> eng_rec;
   clock_t   t1=clock();
  
numb=0;
nframe=0;
int thres =50;
ifstream file3( "c12_siegen_19072017_01", ios::in );
  

     if( !file3 ){
         cerr << "Cant open " << endl;
        }
while( file3 >> part1 >>  num1 >> num2>> num3 )
     {if (nframe>rf)break;
         if (part1 == dd){
         
         xc.push_back( num1);
         yc.push_back( num2);
         engc.push_back( num3);
         numb++;}
        if (part1 == dd2){

         nframe++;
    for (int k2=0;k2<384;k2++){
        for(int j2=0;j2<384;j2++){
    frame[j2][k2]=0;
        }}
///================================starting recombination ======================================================================



for (int i=0;i<xc.size();i++)///filling the frame matrix
 {
frame[xc[i]][yc[i]]=engc[i];
bg[xc[i]][yc[i]]=50;
}

for (int kk=1;kk<384;kk++){
for(int jj=1;jj<384;jj++){
int k= jj, j=kk; 
if (frame[j][k]>bg[j][k]){   
    
    ///================================single=======================
 if(frame[j+1][k]<bg[j+1][k] && frame[j][k+1]<bg[j][k+1] &&frame[j-1][k]<bg[j-1][k]&&frame[j][k-1]<bg[j-1][k] ){

x_rec.push_back(j);
y_rec.push_back(k);
eng_rec.push_back(frame[j][k]);
frame[j][k]=0;
}
///================================double=======================
  /////==========horizontal double============================================
 else if(frame[j+1][k]>bg[j+1][k] &&frame[j+2][k]<bg[j+2][k]&&frame[j][k+1]<bg[j][k+1] &&frame[j-1][k]<bg[j-1][k]&&frame[j][k-1]<bg[j][k-1]&&frame[j+1][k+1]<bg[j+1][k+1]&&frame[j+1][k-1]<bg[j+1][k-1] ) {
   
    eng_rec.push_back((frame[j][k]+frame[j+1][k]));
    if(frame[j][k]>frame[j+1][k]){
        x_rec.push_back(j);
        y_rec.push_back(k);
    }
    else{
        x_rec.push_back(j+1);
        y_rec.push_back(k);
    }
    frame[j][k]=0;
    frame[j+1][k]=0;}
    ////===============================vertical double ========================================
 else if(frame[j][k+1]>bg[j][k+1]&&frame[j+1][k]<bg[j+1][k] &&frame[j][k+2]<bg[j][k+2] && frame[j+1][k+1]<bg[j+1][k+1]&&frame[j-1][k]<bg[j-1][k]&&frame[j-1][k+1]<bg[j-1][k+1]&&frame[j][k-1]<bg[j][k-1]) {
    
     eng_rec.push_back((frame[j][k]+frame[j][k+1]));
    if(frame[j][k]>frame[j][k+1]){
        x_rec.push_back(j);
        y_rec.push_back(k);
    }
    else{
        x_rec.push_back(j);
        y_rec.push_back(k+1);
    }
    frame[j][k]=0;
    frame[j][k+1]=0;}

///================================quadrad=======================

else if(frame[j+1][k]>bg[j+1][k]&&frame[j+1][k+1]>bg[j+1][k+1]&&frame[j][k+1]>bg[j][k+1]&&frame[j+2][k]<bg[j+2][k]&&frame[j-1][k]<bg[j-1][k]&&frame[j][k-1]<bg[j][k-1]&&frame[j+1][k-1]<bg[j+1][k-1]
  && frame[j+2][k+1]<bg[j+2][k+1] && frame[j-1][k+1]<bg[j-1][k+1] && frame[j][k+2]<bg[j][k+2] && frame[j+1][k+2]<bg[j+1][k+2] )
{
   
  eng_rec.push_back((frame[j][k]+frame[j][k+1]+frame[j+1][k]+frame[j+1][k+1]));
if(frame[j][k]>frame[j+1][k]&&frame[j][k]>frame[j][k+1]&&frame[j][k]>frame[j+1][k+1]){
     x_rec.push_back(j);
    y_rec.push_back(k);
}
else if(frame[j+1][k]>frame[j][k]&&frame[j+1][k]>frame[j][k+1]&&frame[j+1][k]>frame[j+1][k+1]){
    x_rec.push_back(j+1);
    y_rec.push_back(k);}
else if(frame[j][k+1]>frame[j][k]&&frame[j][k+1]>frame[j+1][k]&&frame[j][k+1]>frame[j+1][k+1]){
    x_rec.push_back(j);
    y_rec.push_back(k+1);
}
else{

     x_rec.push_back(j+1);
     y_rec.push_back(k+1);
}
//cout<<  frame[j][k]<<"  "<<frame[j][k+1]<<"  "<<frame[j+1][k]<<"  "<<frame[j+1][k+1]<<endl;
   frame[j][k]=0;
    frame[j][k+1]=0;
   frame[j+1][k]=0;
    frame[j+1][k+1]=0;
}



//==================================================================

///================================triple L=======================

else if(frame[j+1][k+1]>thres && frame[j][k+1]>thres &&frame[j+1][k]<thres&&frame[j][k+2]<thres&&frame[j+1][k+2]<thres&&frame[j][k-1]<thres&&frame[j-1][k]<thres&&frame[j-1][k+1]<thres&&frame[j+2][k+1]<thres&&frame[j][k+1]>frame[j][k]&&frame[j][k+1]>frame[j+1][k+1])
{
   
   eng_rec.push_back((frame[j][k]+frame[j][k+1]+frame[j+1][k+1]));
    x_rec.push_back(j);
    y_rec.push_back(k+1);
    frame[j][k]=0;
    frame[j][k+1]=0;
  frame[j+1][k+1]=0;
}


///============================triple J========================================================
else if (frame[j-1][k+1]>thres && frame[j][k+1]>thres&&frame[j+1][k]<thres &&frame[j-1][k]<thres&&frame[j][k-1]<thres&&frame[j-2][k+1]<thres&&frame[j-1][k+2]<thres
&&frame[j][k+2]<thres&&frame[j+1][k+1]<thres&&frame[j][k+1]>frame[j][k]&&frame[j][k+1]>frame[j-1][k+1] )
{
  
   eng_rec.push_back((frame[j][k]+frame[j-1][k+1]+frame[j][k+1]));
    x_rec.push_back(j);
    y_rec.push_back(k+1);
    
    frame[j][k]=0;
    frame[j-1][k+1]=0;
    frame[j][k+1]=0;
}
///================================== triple F ===================================

 else if(frame[j][k+1]>thres &&frame[j+1][k]>thres&&frame[j+2][k]<thres &&frame[j][k+2]<thres&&frame[j+1][k+1]<thres&&frame[j][k-1]<thres&&
frame[j+1][k-1]<thres&&frame[j-1][k]<thres&&frame[j-1][k+1]<thres&&frame[j][k]>frame[j+1][k]&&frame[j][k]>frame[j][k+1])
{
   
   eng_rec.push_back((frame[j][k]+frame[j+1][k]+frame[j][k+1]));
    x_rec.push_back(j);
    y_rec.push_back(k);
   frame[j][k]=0;
    frame[j][k+1]=0;
   frame[j+1][k]=0;
}

///====================================== triple 7 ====================================================

 else if(frame[j+1][k]>thres &&frame[j+1][k+1]>thres&&frame[j-1][k]<thres&&frame[j][k-1]<thres&&frame[j][k+1]<thres&&frame[j+1][k+2]<thres&&frame[j+1][k-1]<thres
&&frame[j+2][k]<thres &&frame[j+2][k+1]<thres&&frame[j+1][k]>frame[j][k]&&frame[j+1][k]>frame[j+1][k+1] 
)
{
   
   eng_rec.push_back((frame[j][k]+frame[j+1][k+1]+frame[j+1][k]));
    x_rec.push_back(j+1);
    y_rec.push_back(k);
    frame[j][k]=0;
    frame[j+1][k]=0;
    frame[j+1][k+1]=0;
}

}}}
xc.clear();
yc.clear();
engc.clear();
        
    
}}
 clock_t t=clock();  









cout<<"The total number of frames= "<<nframe<<endl; 
cout<<"The total number of frames= "<<cou2<<endl;
float gpu_time =((float)(tGf-tG0))/(CLOCKS_PER_SEC);
printf ("The GPU   (%f sec).\n",gpu_time);
float cpu_time =((float)(t-t1))/(CLOCKS_PER_SEC);
printf ("The CPU   (%f sec).\n",cpu_time);
float speed_up = (cpu_time/gpu_time)/75;
printf ("SU   (%f ).\n", ceil(speed_up));
cudaFree(d_yin);
cudaFree(d_xin);
cudaFree(d_engin);
cudaFree(d_engres);
cudaFree(d_xres);
cudaFree(d_yres);
cudaFree(d_ind);
delete[] x;
delete[] y;
delete[] eng;
return 0 ;
}
