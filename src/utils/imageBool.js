export const isImage = (url) => {
  if (typeof (url) === 'string')
    return /\.(jpg|jpeg|png|webp|avif|gif|svg)$/.test(url);
  return false;
}