function [G,B]=GenerateY(Nodes,AC_I,AC_J,AC_Z,AC_y,Trans_I,Trans_J,Trans_k)
Y=zeros(length(Nodes),length(Nodes));
% ���ɽڵ㵼�ɾ���
%�����Ե���
for i=1:length(Nodes) %����ÿ���ڵ�
    index1=find(AC_I==Nodes(i));
    index2=find(AC_J==Nodes(i));
    for k=1:length(index1)
        index_trans=find(Trans_I==Nodes(i));
        if isempty(index_trans)==1   %������ѹ��
            Y(i,i)=Y(i,i)+1/AC_Z(index1(k))+AC_y(index1(k));
        else %�����ǰ֧·����ѹ���ҵ�ǰ�ڵ�����k��
            Y(i,i)=Y(i,i)+1/(Trans_k(index_trans)^2*AC_Z(index1(k)))+AC_y(index1(k));
        end
    end
    for k=1:length(index2)
        index_trans=find(Trans_I==Nodes(i));
        if isempty(index_trans)==1   %������ѹ��
            Y(i,i)=Y(i,i)+1/AC_Z(index2(k))+AC_y(index2(k));
        else %�����ǰ֧·����ѹ���ҵ�ǰ�ڵ�����k��
            Y(i,i)=Y(i,i)+1/(Trans_k(index_trans)^2*AC_Z(index2(k)))+AC_y(index2(k));
        end
    end
end

%���㻥����
for i=1:length(AC_I) %�������еı�
    index3=find(Nodes==AC_I(i)); %�ҵ���ǰ����i�¶�Ӧ�������ڵ�
    index4=find(Nodes==AC_J(i));
    %һ����ѹ����һ���������ĸ�� �������һ���ڵ��������ѹ�������
    index3_transI=find(Trans_I==Nodes(index3));
    index3_transJ=find(Trans_J==Nodes(index3));
    %һ���ڵ����඼������ѹ��֧·��һ��������ѹ��
    if isempty(index3_transI)==1&&isempty(index3_transJ)==1
        Y(index3,index4)=-1/AC_Z(i);
        Y(index4,index3)=-1/AC_Z(i);
    elseif isempty(index3_transI)==0&&isempty(index3_transJ)==1  %����ڵ��ڱ�ѹ��I��
        for j=1:length(index3_transI) % Ѱ����J��Ľڵ��Ƿ���index4��
            if Trans_J(index3_transI(j))==Nodes(index4) %����ҵ���
                K=Trans_k(index3_transI(j));%������
                Y(index3,index4)=-1/(K*AC_Z(i));
                Y(index4,index3)=Y(index3,index4);
                break;
            end
            %���û�ҵ� ˵���˴μ�����֧·������ѹ��
            if j==length(index3_transI)
                Y(index3,index4)=-1/(AC_Z(i));
                Y(index4,index3)=Y(index3,index4);
            end
        end
    elseif isempty(index3_transJ)==0&&isempty(index3_transI)==1
        for j=1:length(index3_transJ) % Ѱ����J��Ľڵ��Ƿ���index4��
            if Trans_I(index3_transJ(j))==Nodes(index4) %����ҵ���
                K=Trans_k(index3_transJ(j));%������
                Y(index3,index4)=-1/(K*AC_Z(i));
                Y(index4,index3)=Y(index3,index4);
                break;
            end
            %���û�ҵ� ˵���˴μ�����֧·������ѹ��
            if j==length(index3_transJ)
                Y(index3,index4)=-1/(AC_Z(i));
                Y(index4,index3)=Y(index3,index4);
            end
        end
    end   
end
Y(3,3)=Y(3,3)+0.04j;
G=real(Y);B=imag(Y);
end