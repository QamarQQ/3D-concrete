function [elementStiffness] = constitutiveModel(cement,ballast,ITZ,iel,interfaceVoxel,crackDiffusivityTensor)

elementStiffness = (interfaceVoxel.volume.ballast(iel)*ballast.diffusionCoefficient + interfaceVoxel.volume.cement(iel)*cement.diffusionCoefficient)/(interfaceVoxel.volume.ballast(iel) + interfaceVoxel.volume.cement(iel))*eye(3) ...
                  + interfaceVoxel.area.ITZ(iel)*ITZ.diffusionCoefficient/(interfaceVoxel.volume.ballast(iel) + interfaceVoxel.volume.cement(iel))*(eye(3) - interfaceVoxel.surfaceNormal(iel,:)'*interfaceVoxel.surfaceNormal(iel,:))...
                  + crackDiffusivityTensor;
end