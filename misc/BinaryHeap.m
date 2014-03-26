%% BinaryHeap
% an implementation of binary heap

classdef BinaryHeap

    properties (SetAccess = protected)
        node;   % array, node in the heap
        priority; % priority of node
        sz;     % current size of the heap
    end
    methods
        function BH = BinaryHeap(n)
            BH.node = zeros(n,1);
            BH.priority = zeros(n,1);
            BH.sz = 0;        
        end

        function [node,priority] = peek(BH)
            if BH.sz
                node = BH.node(1);
                priority = BH.priority(1);
            end
        end

        function BH = add(BH,index,priority)
            BH.sz = BH.sz+1;
            BH.node(BH.sz) = index;
            BH.priority(BH.sz) = priority;
            BH = BH.bubbleup();
        end

        function [BH,node,priority] = remove(BH)
            if BH.sz == 0
                node = 0;
                priority = 0;                
            else
                [node,priority] = peek(BH);
                BH.node(1) = BH.node(BH.sz);
                BH.node(BH.sz) = 0;
                BH.priority(1) = BH.priority(BH.sz);
                BH.priority(BH.sz) = 0;
                BH.sz = BH.sz-1;
                BH = bubbledown(BH);
            end
        end
        function BH = bubbleup(BH,index)
            if ~exist('index','var')
                index = BH.sz;
            end
            while BH.parent(index) && BH.priority(BH.parent(index)) > BH.priority(index)
                % parent/child are out of order; swap them
                BH = BH.swap(index, BH.parent(index));
                index = BH.parent(index);        
            end
        end
        function p = parent(BH,index)            
            p = floor(index/2);
            if index <= 1
                p = 0;
            end
        end
        function lc = leftchild(BH,index)            
            lc = index*2;
            if lc > BH.sz
                lc = 0;
            end
        end
        function rc = rightchild(BH,index)
            rc = index*2+1;
            if rc > BH.sz
                rc = 0;
            end
        end
        function BH = bubbledown(BH)
            index = 1;        
            % bubble down
            while index*2 < BH.sz
%             while BH.leftchild(index)
                % which of my children is smaller?
%                 sc = BH.leftchild(index);        
%                 rc = BH.rightchild(index);
                sc = index*2;
                rc = index*2+1;
                % bubble with the smaller child, if I have a smaller child
                if rc < BH.sz && BH.priority(sc) > BH.priority(rc)
                    sc = rc;
                end
                if BH.priority(index) > BH.priority(sc)
%                     BH = BH.swap(index, sc);
                    BH.node([index,sc]) = BH.node([sc,index]);
                    BH.priority([index,sc]) = BH.priority([sc,index]);
                else
                    break;
                end
                % make sure to update loop counter/index of where last el is put
                index = sc;
            end
        end
        % decease the priority of given node with index
        function BH = decrease_prioirty(BH,index,priority)
            i = BH.node == index;
            BH.priority(i) = priority;
            BH = bubbleup(BH,find(i));
        end
        function BH = swap(BH,index1,index2)
            BH.node([index1,index2]) = BH.node([index2,index1]);
            BH.priority([index1,index2]) = BH.priority([index2,index1]);
        end
    end
end