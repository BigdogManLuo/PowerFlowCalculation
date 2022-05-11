function [Nodes,P_s,Q_s,V0,theta0,n,n_pq,n_pv,n_bal]=DataProcess(Nodes_old,NodeType_old,Load,LD_P,LD_Q,transNodes,Gen,GE_P,GE_V,GE_theta)

%�ڵ���
n=length(Nodes_old);%�ܽڵ���
%����ת�ƽڵ�����
if transNodes==" "
    n_pq=length(Load);%PQ�ڵ���
else
    n_pq=length(Load)+length(transNodes);%PQ�ڵ���
end

n_pv=length(Gen)-1;%PV�ڵ���
n_bal=1;%ƽ��ڵ���

%Ԥ��ֵ
V0=ones(1,n);
theta0=zeros(1,n);
P_s=[];
Q_s=[];

%�ڵ�˳���滻 ��PQ PV SLACK ��������ڵ���
index_PQ=find(NodeType_old=="PQ");
index_PV=find(NodeType_old=="PV");
index_Slack=find(NodeType_old=="Slack");
Nodes=[Nodes_old(index_PQ),Nodes_old(index_PV),Nodes_old(index_Slack)];

%�����ڵ��ע�빦��
for i=1:n_pq  %�����µĽڵ���Nodes  ��ֵ���е�PQ�ڵ�
    index1=find(Load==Nodes(i));
    index2=find(transNodes==Nodes(i));
    if isempty(index1)==1&&isempty(index2)==0 %�������ڵ���Ϊת�ƽڵ�
        P_s=[P_s,0];
        Q_s=[Q_s,0];
    elseif isempty(index1)==0&&isempty(index2)==1 %�������ڵ���Ϊ���ɽڵ�
        P_s=[P_s,LD_P(index1)];
        Q_s=[Q_s,LD_Q(index1)];
    else
        %�������˵��û�и��ɽڵ�
    end
end

for i=n_pq+1:n_pq+n_pv %��ֵPV�ڵ�
    ;
    index=find(Gen==Nodes(i));
    P_s=[P_s,GE_P(index)];
    V0(i)=GE_V(index);
end
index_temp=find(Gen==Nodes(length(Nodes))); %�����������Nodes�����һ���ڵ�ΪSlACK
theta0(length(Nodes))=GE_theta;
V0(length(Nodes))=GE_V(index_temp);