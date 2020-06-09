function varargout = testplot(x,y,varargin)
    [varargout{1:nargout}] = plot(x,y,varargin{:},'Color',[1,0,0]);
end 