function modTime = getLastChangeTime(fileName)
listing = dir(fileName);
% check we got a single entry corresponding to the file
assert(numel(listing) == 1, 'No such file: %s', fileName);
% modTime = datetime(listing.date, 'Locale', 'system');
modTime = datetime(listing.datenum,'ConvertFrom','datenum');
end