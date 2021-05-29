//
//  Solution.swift
//  UIRubic
//
//  Created by Михаил Фокин on 27.05.2021.
//

import Foundation

class Solution {
    var cube: Cube
    
    init(cube: Cube) {
        cube.path.removeAll()
        self.cube = cube
    }
    
    func solution() -> Cube {
        stepFirst()
        stepSecond()
        stepThree()
        stepFour()
        stepFive()
        return self.cube
    }
    
    // MARK: Первый этап. Правильный крест.
    // Повторять пока не будет получаться цветок.
    private func stepFirst() {
        while !isFlower() {
            flower()
        }
        cross()
    }

    // Проверяет достигли ли состояния "цветка"
    private func isFlower() -> Bool {
        return
            self.cube.faces[4].matrix[1][0] == .white &&
            self.cube.faces[4].matrix[2][1] == .white &&
            self.cube.faces[4].matrix[1][2] == .white &&
            self.cube.faces[4].matrix[0][1] == .white
    }
    
    // Собираем ромашку.
    private func flower() {
        // Грань L
        if cube.faces[0].matrix[1][0] == .white {
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .counterclockwise)  // B'
        }
        if cube.faces[0].matrix[1][2] == .white {
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .clockwise)        // F
        }
        if cube.faces[0].matrix[0][1] == .white {
            cube.flipLeft(turn: .counterclockwise)  // L'
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .counterclockwise)  // B'
        }
        if cube.faces[0].matrix[2][1] == .white {
            cube.flipLeft(turn: .clockwise)         // L
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .counterclockwise)  // B'
        }
        
        // Грань F
        if cube.faces[1].matrix[1][0] == .white {
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[1].matrix[1][2] == .white {
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .clockwise)        // R
        }
        if cube.faces[1].matrix[0][1] == .white {
            cube.flipFront(turn: .counterclockwise) // F'
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[1].matrix[2][1] == .white {
            cube.flipFront(turn: .clockwise)        // L
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        
        // Грань R
        if cube.faces[2].matrix[1][0] == .white {
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .counterclockwise) //F'
        }
        if cube.faces[2].matrix[1][2] == .white {
            isAveilable(i: 0, j: 1)
            cube.flipBack(turn: .clockwise)         // B
        }
        if cube.faces[2].matrix[0][1] == .white {
            cube.flipRight(turn: .counterclockwise) // R'
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .counterclockwise) // F'
        }
        if cube.faces[2].matrix[2][1] == .white {
            cube.flipRight(turn: .clockwise)        // R
            isAveilable(i: 2, j: 1)
            cube.flipFront(turn: .counterclockwise) // F'
        }
        
        // Грань B
        if cube.faces[3].matrix[1][0] == .white {
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .counterclockwise) // R'
        }
        if cube.faces[3].matrix[1][2] == .white {
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .clockwise)         // L
        }
        if cube.faces[3].matrix[0][1] == .white {
            cube.flipBack(turn: .counterclockwise)  // B'
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .counterclockwise) // R'
        }
        if cube.faces[3].matrix[2][1] == .white {
            cube.flipBack(turn: .clockwise)         // B
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .counterclockwise) // R'
        }
        
        // Грань D
        if cube.faces[5].matrix[1][0] == .white {
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[5].matrix[1][2] == .white {
            isAveilable(i: 1, j: 2)
            cube.flipRight(turn: .clockwise)        // R
            cube.flipRight(turn: .clockwise)        // R
        }
        if cube.faces[5].matrix[0][1] == .white {
            cube.flipDown(turn: .counterclockwise)  // D'
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
        if cube.faces[5].matrix[2][1] == .white {
            cube.flipDown(turn: .clockwise)         // D'
            isAveilable(i: 1, j: 0)
            cube.flipLeft(turn: .counterclockwise)  // L'
            cube.flipLeft(turn: .counterclockwise)  // L'
        }
    }
    
    // Поворачивает верхнюю грань для освобождения свободного места.
    private func isAveilable(i: Int, j: Int) {
        while self.cube.faces[4].matrix[i][j] == .white {
            self.cube.flipUp(turn: .clockwise)
        }
    }
    
    // Перебирает грани с 0 по 3 и подводит к ним номера кубиков [1, 11, 19, 9].
    private func cross() {
        for (face, number) in zip(self.cube.faces[0...3], [1, 11, 19, 9]) {
            moveNumberForCross(face: face, number: number)
            self.cube.flip(face.flip)
            self.cube.flip(face.flip)
        }
    }
    
    private func moveNumberForCross(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 2, 1)
        case .F:
            coordinate = (1, 2, 2)
        case .R:
            coordinate = (2, 2, 1)
        case .B:
            coordinate = (1, 2, 0)
        default:
            coordinate = (0, 0, 0)
            print("Error move number for cross.")
        }
        while self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != Int8(number) {
            self.cube.flip(.U)
        }
    }
    
    //MARK: Второй этап. Первый слой.
    // Перебор граней от 0 до 3. [2, 20, 18, 0] - номера кубиков, которе должны переместить.
    private func stepSecond() {
        for (face, number) in zip(self.cube.faces[0...3], [2, 20, 18, 0]) {
            if isNumberInCornerUp(number: number) {
                moveNumberToCorner(face: face, number: number)
                moveNuberToDown(face: face, number: number)
            } else {
                let faceOnePifPaf = moveNuberFromDown(number: number)!
                pifPafRight(face: faceOnePifPaf)
                moveNumberToCorner(face: face, number: number)
                moveNuberToDown(face: face, number: number)
            }
        }
    }
    
    // Комбинация пиф-паф (относительно текущей грани face R U R' U')
    private func pifPafRight(face: Face) {
        let flipRight = face.flip.faceRight()!
        self.cube.flip(flipRight)
        self.cube.flip(.U)
        self.cube.flip(flipRight.faceOpposite()!)
        self.cube.flip(._U)
    }
    
    // Комбинация пиф-паф влево (относительно текущей грани face L' U' L U)
    private func pifPafLeft(face: Face) {
        let flipLeft = face.flip.faceLeft()!
        self.cube.flip(flipLeft.faceOpposite()!)
        self.cube.flip(._U)
        self.cube.flip(flipLeft)
        self.cube.flip(.U)
    }
    
    // Проверка находится ли номер в верхнем слое в УГЛАХ (где Up)
    private func isNumberInCornerUp(number: Int) -> Bool {
        return
            self.cube.numbers[0][2][0] == Int8(number) ||
            self.cube.numbers[0][2][2] == Int8(number) ||
            self.cube.numbers[2][2][2] == Int8(number) ||
            self.cube.numbers[2][2][0] == Int8(number)
    }
    
    // Проверка находится ли номер в верхнем слое в ЦЕНТРЕ (где Up)
    private func isNumberInCentreUp(number: Int) -> Bool {
        return
            self.cube.numbers[0][2][1] == Int8(number) ||
            self.cube.numbers[1][2][2] == Int8(number) ||
            self.cube.numbers[2][2][1] == Int8(number) ||
            self.cube.numbers[1][2][0] == Int8(number)
    }
    
    
    // Передвижение номера в правый верхний угол заданной грани. Координаты этих углов.
    private func moveNumberToCorner(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 2, 2)
        case .F:
            coordinate = (2, 2, 2)
        case .R:
            coordinate = (2, 2, 0)
        case .B:
            coordinate = (0, 2, 0)
        default:
            print("Error move number.")
            coordinate = (0, 0, 0)
        }
        while self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != number {
            self.cube.flip(.U)
        }
    }
    
    // Перемещение с помощью пиф-паф помещаем номера в правый нижний угол грани в нижний ряд (где Down).
    private func moveNuberToDown(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 0, 2)
        case .F:
            coordinate = (2, 0, 2)
        case .R:
            coordinate = (2, 0, 0)
        case .B:
            coordinate = (0, 0, 0)
        default:
            print("Error move number.")
            coordinate = (0, 0, 0)
        }
        while self.cube.faces[face.index].matrix[2][2] != face.color || self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != number {
            pifPafRight(face: face)
        }
    }
    
    // Поднимаем кубик из нижней грани наверх.
    private func moveNuberFromDown(number: Int) -> Face? {
        switch Int8(number) {
        case self.cube.numbers[0][0][2]:
            return self.cube.faces[0]
        case self.cube.numbers[2][0][2]:
            return self.cube.faces[1]
        case self.cube.numbers[2][0][0]:
            return self.cube.faces[2]
        case self.cube.numbers[0][0][0]:
            return self.cube.faces[3]
        default:
            return nil
        }
    }
    
    // MARK: Этап третий. Средний слой.
    private func stepThree() {
        while !isSecondLayer() {
            forFlipRight()
            forFlipLeft()
            rotateRightsNumber()
        }
    }
    
    // Проверяет собран ли второй слой. Слева и справа цвета от центра должны совпадать.
    private func isSecondLayer() -> Bool {
        for face in self.cube.faces[0...3] {
            if face.matrix[1][0] != face.color || face.matrix[1][2] != face.color {
                return false
            }
        }
        return true
    }
    
    // Для поворота из центральной верхней точки грани вправо.
    private func forFlipRight() {
        for (face, number) in zip(self.cube.faces[0...3], [5, 23, 21, 3]) {
            if isNumberInCentreUp(number: number) {
                moveNumberToСentre(face: face, number: number)
                self.cube.flip(.U)
                pifPafRightLeft(face: face)
            }
        }
    }
    
    // Для поворота из центральной верхней точки грани влево.
    private func forFlipLeft() {
        for (face, number) in zip(self.cube.faces[0...3], [3, 5, 23, 21]) {
            if isNumberInCentreUp(number: number) {
                moveNumberToСentre(face: face, number: number)
                self.cube.flip(._U)
                pifPafLeftRight(face: face)
            }
        }
    }
    
    // Разворачавает цвета в правом центрально кубике текущей грани. Меняет их местами.
    private func rotateRightsNumber() {
        for face in self.cube.faces[0...3] {
            if face.matrix[1][2] != face.color {
                pifPafRightLeft(face: face)
                return
            }
        }
    }
    
    // Комбинация R U R' U' -> L' U' L U
    private func pifPafRightLeft(face: Face) {
        pifPafRight(face: face)
        pifPafLeft(face: self.cube.faces[(face.index + 1) % 4])
    }
    
    // Комбинация L' U' L U <- R U R' U'
    private func pifPafLeftRight(face: Face) {
        pifPafLeft(face: face)
        let index = (face.index - 1) < 0 ? 4 : face.index - 1
        pifPafRight(face: self.cube.faces[index])
    }
    
    // Передвижение номера в центры верхней грани. Координаты этих углов.
    private func moveNumberToСentre(face: Face, number: Int) {
        let coordinate: (Int, Int, Int)
        switch face.flip {
        case .L:
            coordinate = (0, 2, 1)
        case .F:
            coordinate = (1, 2, 2)
        case .R:
            coordinate = (2, 2, 1)
        case .B:
            coordinate = (1, 2, 0)
        default:
            print("Error move number to centre.")
            coordinate = (0, 0, 0)
        }
        while self.cube.numbers[coordinate.0][coordinate.1][coordinate.2] != number {
            self.cube.flip(.U)
        }
    }
    
    // MARK: Этап четвертый. Сборка последнего слоя.
    private func stepFour() {
        if !isYellowCross() {
            yellowDot()
            yellowHalfCross()
            yellowStick()
        }
    }
    
    // Если вверху палка.
    private func yellowStick() {
        print("yellowStick")
        let faceUp = self.cube.faces[4]
        if faceUp.matrix[1][0] == .yellow && faceUp.matrix[1][2] == .yellow {
            self.cube.flip(.F)
            pifPafRight(face: self.cube.getFase(type: .f))
            self.cube.flip(._F)
        }
        if faceUp.matrix[2][1] == .yellow && faceUp.matrix[0][1] == .yellow {
            self.cube.flip(.R)
            pifPafRight(face: self.cube.getFase(type: .r))
            self.cube.flip(._R)
        }
    }
    
    // Если вверху палка.
    private func yellowHalfCross() {
        print("yellowHalfCross")
        let faceUp = self.cube.faces[4]
        if faceUp.matrix[1][2] == .yellow && faceUp.matrix[0][1] == .yellow {
            self.cube.flip(.L)
            pifPafRight(face: self.cube.getFase(type: .l))
            self.cube.flip(._L)
        }
        if faceUp.matrix[0][1] == .yellow && faceUp.matrix[1][0] == .yellow {
            self.cube.flip(.F)
            pifPafRight(face: self.cube.getFase(type: .f))
            self.cube.flip(._F)
        }
        if faceUp.matrix[1][0] == .yellow && faceUp.matrix[2][1] == .yellow {
            self.cube.flip(.R)
            pifPafRight(face: self.cube.getFase(type: .r))
            self.cube.flip(._R)
        }
        if faceUp.matrix[2][1] == .yellow && faceUp.matrix[1][2] == .yellow {
            self.cube.flip(.B)
            pifPafRight(face: self.cube.getFase(type: .b))
            self.cube.flip(._B)
        }
    }
    
    // Если точка вверхней части.
    private func yellowDot() {
        print("yellowDot")
        let faceUp = self.cube.faces[4]
        if faceUp.matrix[1][0] != .yellow && faceUp.matrix[2][1] != .yellow &&
            faceUp.matrix[1][2] != .yellow && faceUp.matrix[0][1] != .yellow {
            self.cube.flip(.L)
            pifPafRight(face: self.cube.getFase(type: .l))
            self.cube.flip(._L)
        }
    }
    
    // Проверяет наличие желтого креста в верхнем слое (Up)
    private func isYellowCross() -> Bool {
        return
            self.cube.faces[4].matrix[1][0] == .yellow &&
            self.cube.faces[4].matrix[2][1] == .yellow &&
            self.cube.faces[4].matrix[1][2] == .yellow &&
            self.cube.faces[4].matrix[0][1] == .yellow
    }
    
    // MARK: Пятый этап. Првильный желтый крест.
    // MARK: Пятый этап. Првильный желтый крест.
    private func stepFive() {
        moveLocationRight(number: 25)
        if isCross(cube: cube) {
            return
        }
        if let number = inNearby() {
            print("Nearby")
            moveLocationRight(number: number)
            caseNearby()
        } else {
            // Возможно в дальнейшем можно будет убрать.
            print("Opposite")
            caseOpposite()
            if let number = inNearby() {
                print("222Nearby")
                moveLocationRight(number: number)
                caseNearby()
            }
            //cross(cube: cube)
        }
        moveLocationRight(number: 25)
    }

    // Проверяет являтся ли числа соседними
    private func inNearby() -> Int8? {
        let cube = self.cube
        if isNeighbors(left: cube.numbers[0][2][1], rigth: cube.numbers[1][2][2]) {
            return cube.numbers[0][2][1]
        } else if isNeighbors(left: cube.numbers[1][2][2], rigth: cube.numbers[2][2][1]) {
            return cube.numbers[1][2][2]
        } else if isNeighbors(left: cube.numbers[2][2][1], rigth: cube.numbers[1][2][0]) {
            return cube.numbers[2][2][1]
        } else if isNeighbors(left: cube.numbers[1][2][0], rigth: cube.numbers[0][2][1]) {
            return cube.numbers[1][2][0]
        }
        return nil
    }
    
    // Крутим указанное число на правое место в координиту [2][2][1].
    private func moveLocationRight(number: Int8) {
        while cube.numbers[2][2][1] != number {
            self.cube.flip(.U)
        }
    }
    
    // Проверяет являются ли два поданных числа соседними.
    private func isNeighbors(left: Int8, rigth: Int8) -> Bool {
        switch left {
        case 7:
            return rigth == 17
        case 17:
            return rigth == 25
        case 25:
            return rigth == 15
        case 15:
            return rigth == 7
        default:
            return false
        }
    }
    
    // Комбинация для случая "Рядом"
    private func caseNearby() {
        self.cube.flip(.R)
        self.cube.flip(.U)
        self.cube.flip(._R)
        self.cube.flip(.U)
        self.cube.flip(.R)
        self.cube.flip(.U)
        self.cube.flip(.U)
        self.cube.flip(._R)
        self.cube.flip(.U)
    }
    
    // Комбинация для случая "Напротив"
    private func caseOpposite() {
        self.cube.flip(.R)
        self.cube.flip(.U)
        self.cube.flip(._R)
        self.cube.flip(.U)
        self.cube.flip(.R)
        self.cube.flip(.U)
        self.cube.flip(.U)
        self.cube.flip(._R)
    }
    
    // Проверяет получился ли крест.
    private func isCross(cube: Cube) -> Bool {
        return
            cube.numbers[0][2][1] == 7 &&
            cube.numbers[2][2][1] == 25 &&
            cube.numbers[1][2][0] == 15 &&
            cube.numbers[1][2][2] == 17
    }
}